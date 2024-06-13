$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "twitch"

require "minitest/autorun"
require "faraday"
require "json"

class Minitest::Test
  def set_client(stub)
    Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test, stubs: stub)
  end

  def stub_response(fixture:, status: 200, headers: { "Content-Type" => "application/json" })
    [ status, headers, File.read("test/fixtures/#{fixture}.json") ]
  end

  def stub_request(path, response:, method: :get, body: {})
    Faraday::Adapter::Test::Stubs.new do |stub|
      arguments = [ method, "/helix/#{path}" ]
      arguments << body.to_json if [ :post, :put, :patch ].include?(method)
      stub.send(*arguments) { |env| response }
    end
  end
end
