require "test_helper"

class BadgesResourceTest < Minitest::Test
  def test_badges_channel
    setup_client
    badges = @client.badges.channel(broadcaster_id: "141981764")

    assert_equal Twitch::Collection, badges.class
    assert badges.data.all? { |badge| badge.is_a?(Twitch::Badge) }
  end

  def test_badges_global
    setup_client
    badges = @client.badges.global

    assert_equal Twitch::Collection, badges.class
    assert badges.data.all? { |badge| badge.is_a?(Twitch::Badge) }
  end
end
