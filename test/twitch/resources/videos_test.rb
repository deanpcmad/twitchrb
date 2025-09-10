require "test_helper"

class VideosResourceTest < Minitest::Test
  def test_videos_list_by_user_id
    setup_client
    videos = @client.videos.list(user_id: "141981764", first: 5)

    assert_equal Twitch::Collection, videos.class
    assert videos.data.count <= 5
    assert videos.data.all? { |video| video.is_a?(Twitch::Video) }
  end

  def test_videos_list_by_game_id
    setup_client
    videos = @client.videos.list(game_id: "33214", first: 3)

    assert_equal Twitch::Collection, videos.class
    assert videos.data.count <= 3
    assert videos.data.all? { |video| video.is_a?(Twitch::Video) }
  end

  def test_videos_list_with_period
    setup_client
    videos = @client.videos.list(user_id: "141981764", period: "week", first: 5)

    assert_equal Twitch::Collection, videos.class
    assert videos.data.count <= 5
    assert videos.data.all? { |video| video.is_a?(Twitch::Video) }
  end

  def test_videos_list_with_sort
    setup_client
    videos = @client.videos.list(user_id: "141981764", sort: "time", first: 5)

    assert_equal Twitch::Collection, videos.class
    assert videos.data.count <= 5
    assert videos.data.all? { |video| video.is_a?(Twitch::Video) }
  end

  def test_videos_list_with_type
    setup_client
    videos = @client.videos.list(user_id: "141981764", type: "archive", first: 5)

    assert_equal Twitch::Collection, videos.class
    assert videos.data.count <= 5
    assert videos.data.all? { |video| video.is_a?(Twitch::Video) }
  end

  def test_videos_list_with_language
    setup_client
    videos = @client.videos.list(user_id: "141981764", language: "en", first: 5)

    assert_equal Twitch::Collection, videos.class
    assert videos.data.count <= 5
    assert videos.data.all? { |video| video.is_a?(Twitch::Video) }
  end

  def test_videos_list_missing_params_raises_error
    setup_client

    assert_raises(RuntimeError) do
      @client.videos.list(first: 5)
    end
  end

  def test_videos_retrieve
    setup_client

    # First get a real video ID from the videos list
    videos = @client.videos.list(user_id: "141981764", first: 1)

    if videos.data.any?
      video_id = videos.data.first.id
      video = @client.videos.retrieve(id: video_id)

      if video
        assert_equal Twitch::Video, video.class
        assert_equal video_id, video.id
      end
    else
      # Skip test if no videos available
      skip "No videos available for user"
    end
  end

  def test_videos_delete_requires_scope
    setup_client

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.videos.delete(video_id: "1234567890")
    end
  end
end
