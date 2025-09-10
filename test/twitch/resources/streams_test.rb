require "test_helper"

class StreamsResourceTest < Minitest::Test
  def test_streams_list
    setup_client
    streams = @client.streams.list(first: 10)

    assert_equal Twitch::Collection, streams.class
    assert streams.data.count <= 10
    assert streams.data.all? { |stream| stream.is_a?(Twitch::Stream) }
  end

  def test_streams_list_by_user_id
    setup_client
    streams = @client.streams.list(user_id: [ "141981764" ])

    assert_equal Twitch::Collection, streams.class
    assert streams.data.all? { |stream| stream.is_a?(Twitch::Stream) }
  end

  def test_streams_list_by_user_login
    setup_client
    streams = @client.streams.list(user_login: [ "twitchdev" ])

    assert_equal Twitch::Collection, streams.class
    assert streams.data.all? { |stream| stream.is_a?(Twitch::Stream) }
  end

  def test_streams_list_by_game_id
    setup_client
    streams = @client.streams.list(game_id: [ "33214" ], first: 5)

    assert_equal Twitch::Collection, streams.class
    assert streams.data.count <= 5
    assert streams.data.all? { |stream| stream.is_a?(Twitch::Stream) }
  end

  def test_streams_list_with_language
    setup_client
    streams = @client.streams.list(language: [ "en" ], first: 3)

    assert_equal Twitch::Collection, streams.class
    assert streams.data.count <= 3
    assert streams.data.all? { |stream| stream.is_a?(Twitch::Stream) }
  end

  def test_streams_list_with_pagination
    setup_client

    # First get real pagination cursor from a streams call
    first_page = @client.streams.list(first: 5)

    if first_page.cursor
      streams = @client.streams.list(first: 5, after: first_page.cursor)

      assert_equal Twitch::Collection, streams.class
      assert streams.data.count <= 5
      assert streams.data.all? { |stream| stream.is_a?(Twitch::Stream) }
    else
      # Test just verifies basic functionality without pagination
      assert_equal Twitch::Collection, first_page.class
      assert first_page.data.count <= 5
      assert first_page.data.all? { |stream| stream.is_a?(Twitch::Stream) }
    end
  end

  def test_streams_followed_requires_scope
    setup_client

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.streams.followed(user_id: "141981764", first: 5)
    end
  end
end
