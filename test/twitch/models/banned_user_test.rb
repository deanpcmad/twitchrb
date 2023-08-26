require "test_helper"

class BannedUserTest < Minitest::Test

  def test_banned_user_list
    users = Twitch::BannedUser.list(broadcaster_id: 943007443)

    assert_equal Twitch::Collection, users.class
    assert_equal Twitch::BannedUser, users.data.first.class
    assert_equal "commanderroot", users.data.first.user_login
  end

  def test_banned_user_create
    user = Twitch::BannedUser.create(broadcaster_id: 943007443, moderator_id: 943007443, user_id: 141981764, reason: "test")

    assert_equal Twitch::BannedUser, user.class
    assert_equal "141981764", user.user_id
  end

  def test_banned_user_delete
    user = Twitch::BannedUser.delete(broadcaster_id: 943007443, moderator_id: 943007443, user_id: 141981764)

    assert user
  end

end
