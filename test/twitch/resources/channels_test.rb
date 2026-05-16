require "test_helper"

class ChannelsResourceTest < WebmockTest
  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_token")
  end

  def test_channels_retrieve
    stub_helix(:get, "channels", query: { "broadcaster_id" => "141981764" }, fixture: "get_channel")

    channel = @client.channels.retrieve(id: 141981764)

    assert_equal Twitch::Channel, channel.class
    assert_equal "twitchdev", channel.broadcaster_login
  end
end
