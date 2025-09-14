require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    Twitch.reset_configuration!
  end

  def teardown
    Twitch.reset_configuration!
  end

  def test_default_configuration
    config = Twitch.configuration

    assert_equal false, config.dev_mode
    assert_equal "https://api.twitch.tv/helix", config.api_url
    assert_equal "https://id.twitch.tv/oauth2", config.oauth_url
    assert_nil config.client_id
    assert_nil config.client_secret
    assert_nil config.access_token
  end

  def test_configure_block
    Twitch.configure do |config|
      config.dev_mode = true
      config.api_url = "http://localhost:3000/api"
      config.oauth_url = "http://localhost:3000/oauth2"
      config.client_id = "test_client_id"
      config.client_secret = "test_client_secret"
      config.access_token = "test_access_token"
    end

    config = Twitch.configuration
    assert_equal true, config.dev_mode
    assert_equal "http://localhost:3000/api", config.api_url
    assert_equal "http://localhost:3000/oauth2", config.oauth_url
    assert_equal "test_client_id", config.client_id
    assert_equal "test_client_secret", config.client_secret
    assert_equal "test_access_token", config.access_token
  end

  def test_reset_configuration
    Twitch.configure do |config|
      config.dev_mode = true
      config.api_url = "http://localhost:3000/api"
      config.client_id = "test_client_id"
      config.access_token = "test_access_token"
    end

    # Verify settings were applied
    assert_equal true, Twitch.configuration.dev_mode
    assert_equal "http://localhost:3000/api", Twitch.configuration.api_url
    assert_equal "test_client_id", Twitch.configuration.client_id
    assert_equal "test_access_token", Twitch.configuration.access_token

    # Reset and verify defaults are restored
    Twitch.reset_configuration!
    assert_equal false, Twitch.configuration.dev_mode
    assert_equal "https://api.twitch.tv/helix", Twitch.configuration.api_url
    assert_nil Twitch.configuration.client_id
    assert_nil Twitch.configuration.access_token
  end

  def test_client_uses_global_configuration
    Twitch.configure do |config|
      config.dev_mode = true
      config.api_url = "http://localhost:3000/api"
      config.client_id = "global_client_id"
      config.access_token = "global_access_token"
    end

    client = Twitch::Client.new

    assert_equal true, client.dev_mode
    assert_equal "http://localhost:3000/api", client.api_url
    assert_equal "global_client_id", client.client_id
    assert_equal "global_access_token", client.access_token
  end

  def test_oauth_uses_global_configuration
    Twitch.configure do |config|
      config.dev_mode = true
      config.oauth_url = "http://localhost:3000/oauth2"
      config.client_id = "global_client_id"
      config.client_secret = "global_client_secret"
    end

    oauth = Twitch::OAuth.new

    assert_equal true, oauth.dev_mode
    assert_equal "http://localhost:3000/oauth2", oauth.oauth_url
    assert_equal "global_client_id", oauth.client_id
    assert_equal "global_client_secret", oauth.client_secret
  end

  def test_instance_parameters_override_global_configuration
    Twitch.configure do |config|
      config.dev_mode = true
      config.api_url = "http://localhost:3000/api"
      config.oauth_url = "http://localhost:3000/oauth2"
      config.client_id = "global_client_id"
      config.client_secret = "global_client_secret"
      config.access_token = "global_access_token"
    end

    # Client instance parameters should override global config
    client = Twitch::Client.new(
      client_id: "instance_client_id",
      access_token: "instance_access_token",
      dev_mode: false,
      api_url: "http://custom-api.com"
    )

    assert_equal false, client.dev_mode
    assert_equal "http://custom-api.com", client.api_url
    assert_equal "instance_client_id", client.client_id
    assert_equal "instance_access_token", client.access_token

    # OAuth instance parameters should override global config
    oauth = Twitch::OAuth.new(
      client_id: "instance_client_id",
      client_secret: "instance_client_secret",
      dev_mode: false,
      oauth_url: "http://custom-oauth.com"
    )

    assert_equal false, oauth.dev_mode
    assert_equal "http://custom-oauth.com", oauth.oauth_url
    assert_equal "instance_client_id", oauth.client_id
    assert_equal "instance_client_secret", oauth.client_secret
  end

  def test_global_config_with_nil_values
    Twitch.configure do |config|
      config.api_url = nil
      config.oauth_url = nil
    end

    # Should fall back to defaults when global config values are nil
    client = Twitch::Client.new(client_id: "test", access_token: "test")
    oauth = Twitch::OAuth.new(client_id: "test", client_secret: "test")

    assert_equal "https://api.twitch.tv/helix", client.api_url
    assert_equal "https://id.twitch.tv/oauth2", oauth.oauth_url
  end
end
