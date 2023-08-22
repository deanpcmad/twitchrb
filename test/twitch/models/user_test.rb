require "test_helper"

class UserTest < Minitest::Test

  def test_user_retrieve_with_id
    user = Twitch::User.retrieve(id: 943007443)

    assert_equal Twitch::User, user.class
    assert_equal "deanpcmadtest", user.display_name
    assert_equal "943007443", user.id
  end

  def test_user_retrieve_with_ids
    users = Twitch::User.retrieve(ids: [943007443, 719509646])

    assert_equal Twitch::Collection, users.class
    assert_equal Twitch::User, users.data.first.class
    assert_equal "deanpcmadtest", users.data.first.display_name
    assert_equal "deanpcmad_test", users.data.last.display_name
  end

  def test_user_retrieve_with_username
    user = Twitch::User.retrieve(username: "deanpcmadtest")

    assert_equal Twitch::User, user.class
    assert_equal "deanpcmadtest", user.display_name
    assert_equal "943007443", user.id
  end

  def test_user_retrieve_with_usernames
    users = Twitch::User.retrieve(usernames: ["deanpcmadtest", "deanpcmad_test"])

    assert_equal Twitch::Collection, users.class
    assert_equal Twitch::User, users.data.first.class
    assert_equal "719509646", users.data.first.id
  end

  def test_user_update
    user = Twitch::User.update(description: "This is a test description")

    assert_equal Twitch::User, user.class
    assert_equal "This is a test description", user.description
  end

  def test_user_get_colour_with_id
    user = Twitch::User.get_colour(id: 943007443)

    assert_equal Twitch::UserColour, user.class
    assert_equal "943007443", user.user_id
  end

  def test_user_get_colour_with_ids
    users = Twitch::User.get_colour(ids: [943007443, 719509646])

    assert_equal Twitch::Collection, users.class
    assert_equal Twitch::UserColour, users.data.first.class
    assert_equal "deanpcmadtest", users.data.first.user_login
    assert_equal "deanpcmad_test", users.data.last.user_login
  end

end
