require "test_helper"

class ChannelsResourceTest < Minitest::Test
  def test_channels_retrieve
    setup_client
    channel = @client.channels.retrieve(id: 141981764)

    assert_equal Twitch::Channel, channel.class
    assert_equal "twitchdev", channel.broadcaster_login
  end
end
