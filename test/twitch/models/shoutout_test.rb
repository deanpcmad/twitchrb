require "test_helper"

class ShoutoutTest < Minitest::Test

  def test_shoutout_create
    shoutout = Twitch::Shoutout.create(from: 943007443, to: 719509646, moderator_id: 943007443)

    assert shoutout
  end

end
