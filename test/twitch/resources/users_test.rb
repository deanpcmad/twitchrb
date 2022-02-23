require "test_helper"

class UsersResourceTest < Minitest::Test

  def test_users_get_by_id
    client = set_client(stub_request("users", response: stub_response(fixture: "users/get")))
    user   = client.users.get_by_id(user_id: 141981764)

    assert_equal Twitch::User, user.class
    assert_equal "twitchdev", user.login
  end

  def test_users_get_by_username
    client = set_client(stub_request("users", response: stub_response(fixture: "users/get")))
    user   = client.users.get_by_username(username: "twitchdev")

    assert_equal Twitch::User, user.class
    assert_equal "partner", user.broadcaster_type
  end

end
