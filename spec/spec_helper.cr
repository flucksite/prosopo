require "spec"
require "webmock"
require "../src/prosopo"

Prosopo.configure do |settings|
  settings.site_key = "aBcDeFgH"
  settings.secret_key = "some very secret key"
end

def read_fixture(file : String)
  path = "#{__DIR__}/fixtures/#{file}"

  File.exists?(path) ||
    raise Exception.new("Fixture #{file} does not exist.")

  File.open(path)
end

Spec.after_each do
  WebMock.reset
end
