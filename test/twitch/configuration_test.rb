require "test_helper"

class ConfigurationTest < Minitest::Test

  def setup
    Twitch.config.client_id = "123abc"
    Twitch.config.access_token = "abc123"
  end

  def test_client_id
    assert_equal "123abc", Twitch.config.client_id
  end

  def test_access_token
    assert_equal "abc123", Twitch.config.access_token
  end

end
