$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "twitch"

require "minitest/autorun"
require "faraday"
require "json"
require "vcr"
require "webmock/minitest"
require "dotenv/load"

WebMock.disable_net_connect!

HELIX_URL = "https://api.twitch.tv/helix".freeze
FIXTURES_DIR = File.expand_path("fixtures", __dir__).freeze

def helix_fixture(name)
  File.read(File.join(FIXTURES_DIR, "helix", "#{name}.json"))
end

def stub_helix(method, path, query: nil, fixture: nil, status: 200, body: nil)
  body ||= fixture ? helix_fixture(fixture) : "{}"
  stub = stub_request(method, "#{HELIX_URL}/#{path}")
  stub = stub.with(query: query) if query
  stub.to_return(status: status, body: body, headers: { "Content-Type" => "application/json" })
end

# Tests that opt out of VCR (WebMock-based) inherit from this class.
class WebmockTest < Minitest::Test
  def setup; end
  def teardown; end
end

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :faraday
  # When no cassette is active, hand the request off to WebMock (used by stub-based tests).
  config.allow_http_connections_when_no_cassette = true

  config.filter_sensitive_data("<AUTHORIZATION>") { ENV["TWITCH_ACCESS_TOKEN"] }
  config.filter_sensitive_data("<CLIENT_SECRET>") { ENV["TWITCH_CLIENT_SECRET"] }
  config.filter_sensitive_data("<CLIENT_ID>") { ENV["TWITCH_CLIENT_ID"] }
  config.filter_sensitive_data("<APP_ACCESS_TOKEN>") do |interaction|
    # Filter any dynamically generated app access tokens
    if interaction.response&.body&.include?("access_token")
      begin
        body = JSON.parse(interaction.response.body)
        body["access_token"] if body.is_a?(Hash)
      rescue
        nil
      end
    end
  end

  # Allow HTTP connections for OAuth endpoints since they work differently
  config.ignore_request do |request|
    request.uri.include?("id.twitch.tv")
  end
end

def setup_client
  @client ||= Twitch::Client.new(client_id: ENV["TWITCH_CLIENT_ID"], access_token: ENV["TWITCH_ACCESS_TOKEN"])
end

def setup_app_client
  @app_client ||= Twitch::Client.new(
    client_id: ENV.fetch("TWITCH_CLIENT_ID", "test_client_id"),
    access_token: "test_app_token"
  )
end

class Minitest::Test
  def setup
    VCR.insert_cassette(name)
  end

  def teardown
    VCR.eject_cassette
  end
end
