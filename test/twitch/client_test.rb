require "test_helper"

class ClientTest < Minitest::Test
  def test_client_id
    client = Twitch::Client.new client_id: "123", client_secret: "abc", access_token: "abc123"
    assert_equal "123", client.client_id
  end

  def test_client_secret
    client = Twitch::Client.new client_id: "123", client_secret: "abc", access_token: "abc123"
    assert_equal "abc", client.client_secret
  end

  def test_access_token
    client = Twitch::Client.new client_id: "123", client_secret: "abc", access_token: "abc123"
    assert_equal "abc123", client.access_token
  end
end
