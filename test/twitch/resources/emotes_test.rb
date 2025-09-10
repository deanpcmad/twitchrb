require "test_helper"

class EmotesResourceTest < Minitest::Test
  def test_emotes_channel
    setup_client
    emotes = @client.emotes.channel(broadcaster_id: "141981764")

    assert_equal Twitch::Collection, emotes.class
    assert emotes.data.all? { |emote| emote.is_a?(Twitch::Emote) }
  end

  def test_emotes_global
    setup_client
    emotes = @client.emotes.global

    assert_equal Twitch::Collection, emotes.class
    assert emotes.data.all? { |emote| emote.is_a?(Twitch::Emote) }
  end

  def test_emotes_sets
    setup_client
    emotes = @client.emotes.sets(emote_set_id: "0")

    assert_equal Twitch::Collection, emotes.class
    assert emotes.data.all? { |emote| emote.is_a?(Twitch::Emote) }
  end
end