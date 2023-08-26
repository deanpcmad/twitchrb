require "test_helper"

class BadgeTest < Minitest::Test

  def test_badge_channel
    badges = Twitch::Badge.channel(broadcaster_id: 13363719)

    assert_equal Twitch::Collection, badges.class
    assert_equal Twitch::Badge, badges.data.first.class
    assert_equal "bits", badges.data.first.set_id
  end

  def test_badge_global
    badges = Twitch::Badge.global

    assert_equal Twitch::Collection, badges.class
    assert_equal Twitch::Badge, badges.data.first.class
  end

end
