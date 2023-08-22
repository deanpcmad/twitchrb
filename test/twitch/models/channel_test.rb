require "test_helper"

class ChannelTest < Minitest::Test

  def test_channel_retrieve
    channel = Twitch::Channel.retrieve(id: 943007443)

    assert_equal Twitch::Channel, channel.class
    assert_equal "deanpcmadtest", channel.broadcaster_login
    assert_equal "943007443", channel.broadcaster_id
  end

  def test_channel_update
    channel = Twitch::Channel.update(id: 943007443, title: "Test stream")
    assert channel
  end

end
