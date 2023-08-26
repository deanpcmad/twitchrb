require "test_helper"

class ClipTest < Minitest::Test

  def test_clip_list_by_broadcaster
    clips = Twitch::Clip.list(broadcaster_id: 72938118)

    assert_equal Twitch::Collection, clips.class
    assert_equal Twitch::Clip, clips.data.first.class
    assert_equal "deanpcmad", clips.data.first.broadcaster_name
  end

  def test_clip_list_by_id
    clips = Twitch::Clip.list(id: "SleepySavageLouseTBTacoRight-UvFOOsTTRu2qbdY9")

    assert_equal Twitch::Collection, clips.class
    assert_equal Twitch::Clip, clips.data.first.class
    assert_equal "deanpcmad", clips.data.first.broadcaster_name
  end

  def test_clip_list_by_game_id
    clips = Twitch::Clip.list(game_id: 1469308723)

    assert_equal Twitch::Collection, clips.class
    assert_equal Twitch::Clip, clips.data.first.class
  end

  def test_clip_retrieve
    clip = Twitch::Clip.retrieve(id: "SleepySavageLouseTBTacoRight-UvFOOsTTRu2qbdY9")

    assert_equal Twitch::Clip, clip.class
    assert_equal "deanpcmad", clip.broadcaster_name
  end

  def test_clip_create
    clip = Twitch::Clip.create(broadcaster_id: 943007443)

    assert_equal Twitch::Clip, clip.class
  end

end
