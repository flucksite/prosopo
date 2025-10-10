require "../spec_helper"

describe Prosopo do
  describe ".verify" do
    it "successfully verifies a valid token" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .to_return(body: read_fixture("success.json").gets_to_end)

      result = Prosopo.verify("GOOD").as(Prosopo::Result)
      result.verified?.should be_truthy
      result.status.should eq("verified")
      result.errors.should eq([] of String)
    end

    it "successfully verifies an invalid token" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .to_return(body: read_fixture("failure.json").gets_to_end)

      result = Prosopo.verify("BAD").as(Prosopo::Result)
      result.verified?.should be_falsey
      result.status.should eq("verification_failed")
      result.errors.as(Array(String)).size.should eq(6)
    end

    it "fails when an invalid JSON response is received" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .to_return(body: "invalid")

      expect_raises(
        Prosopo::ResponseError,
        "Invalid JSON response from Prosopo"
      ) do
        Prosopo.verify("GOOD")
      end
    end

    it "fails when the server responds with an error status code" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .to_return(status: 400)

      expect_raises(
        Prosopo::ResponseError,
        "Prosopo API returned HTTP 400"
      ) do
        Prosopo.verify("GOOD")
      end
    end

    it "sends a descriptive user agent and correct content type" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .with(
          headers: {
            "Content-Type" => "application/json",
            "User-Agent"   => "crystal-prosopo/0.1.0 (Crystal 1.17.1)",
          })
        .to_return(body: read_fixture("success.json").gets_to_end)

      Prosopo.verify("GOOD")
    end

    it "sends JSON request body with correct structure" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .with(
          body: {
            "token"  => "GOOD",
            "secret" => Prosopo.settings.secret_key,
            "ip"     => "192.168.1.1",
          }.to_json
        )
        .to_return(body: read_fixture("success.json").gets_to_end)

      Prosopo.verify("GOOD", "192.168.1.1")
    end

    it "sends JSON request body without user when IP is nil" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .with(
          body: {
            "token"  => "GOOD",
            "secret" => Prosopo.settings.secret_key,
          }.to_json
        )
        .to_return(body: read_fixture("success.json").gets_to_end)

      Prosopo.verify("GOOD")
    end
  end

  describe ".verify?" do
    it "successfully verifies a valid token" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .to_return(body: read_fixture("success.json").gets_to_end)

      Prosopo.verify?("GOOD").should be_truthy
    end

    it "successfully verifies an invalid token" do
      WebMock.stub(:post, "https://api.prosopo.io/siteverify")
        .to_return(body: read_fixture("failure.json").gets_to_end)

      Prosopo.verify?("BAD").should be_falsey
    end
  end
end
