require "test_helper"

class StreamTest < Minitest::Test

  def test_stream_list
    streams = Twitch::Stream.list

    assert_equal Twitch::Collection, streams.class
    assert_equal Twitch::Stream, streams.data.first.class
    assert_equal "live", streams.data.first.type
  end

  def test_stream_list_user
    streams = Twitch::Stream.list(user_id: 943007443)

    assert_equal Twitch::Collection, streams.class
    assert_equal Twitch::Stream, streams.data.first.class
    assert_equal "deanpcmadtest", streams.data.first.user_login
    assert_equal "live", streams.data.first.type
  end

  def test_stream_followed
    streams = Twitch::Stream.followed(user_id: 943007443)

    assert_equal Twitch::Collection, streams.class
    assert_equal Twitch::Stream, streams.data.first.class
    assert_equal "deanpcmad_test", streams.data.first.user_login
    assert_equal "live", streams.data.first.type
  end

end
