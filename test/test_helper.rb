$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "twitch"

require "minitest/autorun"
require "faraday"
require "json"
require "vcr"
require "dotenv/load"

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :faraday

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
  return @app_client if @app_client

  # Create OAuth instance to get app access token
  oauth = Twitch::OAuth.new(
    client_id: ENV["TWITCH_CLIENT_ID"],
    client_secret: ENV["TWITCH_CLIENT_SECRET"]
  )

  # Get app access token
  token_response = oauth.create(grant_type: "client_credentials")
  return nil unless token_response

  @app_client ||= Twitch::Client.new(
    client_id: ENV["TWITCH_CLIENT_ID"],
    access_token: token_response.access_token
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
