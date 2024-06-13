require "test_helper"

class ChannelsResourceTest < Minitest::Test
  def test_channels_retrieve
    stub = stub_request("channels", response: stub_response(fixture: "channels/get"))
    client  = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test, stubs: stub)
    channel = client.channels.retrieve(id: 141981764)

    assert_equal Twitch::Channel, channel.class
    assert_equal "twitchdev", channel.broadcaster_login
  end
end
