require "test_helper"

class EmotesResourceTest < WebmockTest
  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_token")
  end

  def test_emotes_channel
    stub_helix(:get, "chat/emotes", query: { "broadcaster_id" => "141981764" }, fixture: "get_channel_emotes")

    emotes = @client.emotes.channel(broadcaster_id: "141981764")

    assert_equal Twitch::Collection, emotes.class
    assert emotes.data.all? { |emote| emote.is_a?(Twitch::Emote) }
  end

  def test_emotes_global
    stub_helix(:get, "chat/emotes/global", fixture: "get_global_emotes")

    emotes = @client.emotes.global

    assert_equal Twitch::Collection, emotes.class
    assert emotes.data.all? { |emote| emote.is_a?(Twitch::Emote) }
  end

  def test_emotes_sets
    stub_helix(:get, "chat/emotes/set", query: { "emote_set_id" => "0" }, fixture: "get_emote_sets")

    emotes = @client.emotes.sets(emote_set_id: "0")

    assert_equal Twitch::Collection, emotes.class
    assert emotes.data.all? { |emote| emote.is_a?(Twitch::Emote) }
  end
end
