require "http/client"
require "json"

module Prosopo
  extend self

  def verify(
    response_token : String,
    remote_ip : String? = nil,
  ) : Result
    attempts = Prosopo.settings.retry_attempts
    delays = Prosopo.settings.retry_delays.map(&.seconds)

    attempts.succ.times do |attempt|
      begin
        return perform_request(response_token, remote_ip)
      rescue IO::TimeoutError | Socket::ConnectError | Socket::Error
        sleep(delays[attempt]? || delays.last) if attempt < attempts
      end
    end

    raise RequestError.new("Failed to connect to Prosopo service")
  end

  def verify?(
    response_token : String,
    remote_ip : String? = nil,
  ) : Bool
    verify(response_token, remote_ip).verified?
  end

  private def perform_request(
    response_token : String,
    remote_ip : String?,
  )
    url = URI.parse(Prosopo.settings.endpoint)
    client = request_client(url)

    begin
      response = client.post(
        url.path,
        headers: request_headers,
        body: request_body(response_token, remote_ip)
      )

      response.success? ||
        raise ResponseError.new("Prosopo API returned HTTP #{response.status_code}")

      Prosopo::Result.from_json(response.body)
    rescue JSON::ParseException
      raise ResponseError.new("Invalid JSON response from Prosopo")
    ensure
      client.close rescue nil
    end
  end

  private def request_client(url : URI)
    HTTP::Client.new(url).tap do |client|
      client.connect_timeout = Prosopo.settings.timeout
      client.read_timeout = Prosopo.settings.timeout
    end
  end

  private def request_headers
    HTTP::Headers{
      "Content-Type" => "application/json",
      "User-Agent"   => "crystal-prosopo/#{VERSION} (Crystal #{Crystal::VERSION})",
    }
  end

  private def request_body(
    response_token : String,
    remote_ip : String?,
  )
    {
      :token  => response_token,
      :secret => Prosopo.settings.secret_key,
      :ip     => remote_ip,
    }.compact.to_json
  end
end
