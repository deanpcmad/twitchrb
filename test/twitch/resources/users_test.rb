require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_users_retrieve_by_id
    setup_client
    user = @client.users.retrieve(id: 141981764)

    assert_equal Twitch::User, user.class
    assert_equal "twitchdev", user.login
  end

  def test_users_retrieve_by_username
    setup_client
    user = @client.users.retrieve(username: "twitchdev")

    assert_equal Twitch::User, user.class
    assert_equal "partner", user.broadcaster_type
  end

  def test_users_retrieve_by_ids
    setup_client
    users = @client.users.retrieve(ids: [ "141981764", "72938118" ])

    assert_equal Twitch::Collection, users.class
    assert_equal 2, users.data.count
  end

  def test_users_retrieve_by_usernames
    setup_client
    users = @client.users.retrieve(usernames: [ "twitchdev", "deanpcmad" ])

    assert_equal Twitch::Collection, users.class
    assert_equal 2, users.data.count
  end
end
