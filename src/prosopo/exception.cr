module Prosopo
  abstract class Error < Exception; end

  class RequestError < Error; end

  class ResponseError < Error; end
end
