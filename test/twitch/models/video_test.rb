require "test_helper"

class VideoTest < Minitest::Test

  def test_video_list_by_user
    videos = Twitch::Video.list(user_id: 943007443)

    assert_equal Twitch::Collection, videos.class
    assert_equal Twitch::Video, videos.data.first.class
    assert_equal "archive", videos.data.first.type
  end

  def test_video_list_by_id
    videos = Twitch::Video.list(id: 1908988719)

    assert_equal Twitch::Collection, videos.class
    assert_equal Twitch::Video, videos.data.first.class
    assert_equal "archive", videos.data.first.type
  end

  def test_video_list_by_game_id
    videos = Twitch::Video.list(game_id: 1469308723)

    assert_equal Twitch::Collection, videos.class
    assert_equal Twitch::Video, videos.data.first.class
    assert_equal "archive", videos.data.first.type
    assert_equal "deanpcmadtest", videos.data.first.user_login
  end

  def test_video_delete
    video = Twitch::Video.delete(id: 1908988719)

    assert video
  end

end
