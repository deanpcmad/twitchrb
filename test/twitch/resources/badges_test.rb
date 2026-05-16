require "test_helper"

class BadgesResourceTest < WebmockTest
  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_token")
  end

  def test_badges_channel
    stub_helix(:get, "chat/badges", query: { "broadcaster_id" => "141981764" }, fixture: "get_channel_badges")

    badges = @client.badges.channel(broadcaster_id: "141981764")

    assert_equal Twitch::Collection, badges.class
    assert badges.data.all? { |badge| badge.is_a?(Twitch::Badge) }
  end

  def test_badges_global
    stub_helix(:get, "chat/badges/global", fixture: "get_global_badges")

    badges = @client.badges.global

    assert_equal Twitch::Collection, badges.class
    assert badges.data.all? { |badge| badge.is_a?(Twitch::Badge) }
  end
end
