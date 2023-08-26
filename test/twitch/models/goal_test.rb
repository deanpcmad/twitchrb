require "test_helper"

class GoalTest < Minitest::Test

  def test_goal_list
    goals = Twitch::Goal.list(broadcaster_id: 943007443)

    assert_equal Twitch::Collection, goals.class
    assert_equal Twitch::Goal, goals.data.first.class
    assert_equal "follower", goals.data.first.type
  end

end
