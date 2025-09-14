require "test_helper"

class ClientTest < Minitest::Test
  def test_client_id
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_equal "123", client.client_id
  end

  def test_access_token
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_equal "abc123", client.access_token
  end

  def test_default_dev_mode_is_false
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_equal false, client.dev_mode
  end

  def test_dev_mode_can_be_enabled
    client = Twitch::Client.new client_id: "123", access_token: "abc123", dev_mode: true
    assert_equal true, client.dev_mode
  end

  def test_default_api_url_uses_base_url
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_equal Twitch::Client::BASE_URL, client.api_url
  end

  def test_custom_api_url_can_be_set
    custom_url = "http://localhost:3000/api"
    client = Twitch::Client.new client_id: "123", access_token: "abc123", api_url: custom_url
    assert_equal custom_url, client.api_url
  end

  def test_connection_uses_custom_api_url
    custom_url = "http://localhost:3000/api"
    client = Twitch::Client.new client_id: "123", access_token: "abc123", api_url: custom_url

    connection = client.connection
    assert_equal custom_url, connection.url_prefix.to_s
  end

  def test_dev_mode_with_custom_api_url
    custom_url = "http://localhost:3000/api"
    client = Twitch::Client.new client_id: "123", access_token: "abc123", dev_mode: true, api_url: custom_url

    assert_equal true, client.dev_mode
    assert_equal custom_url, client.api_url

    connection = client.connection
    assert_equal custom_url, connection.url_prefix.to_s
  end
end
