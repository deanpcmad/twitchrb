class ErrorTest < Minitest::Test
  def test_bad_request_error
    error = Twitch::ErrorFactory.create(
      { "error" => 123, "message" => "Twitch error message" },
      400
    )

    assert_equal "Error 400: Your request was malformed. 'Twitch error message'", error.message
  end

  def test_authentication_missing_error
    error = Twitch::ErrorFactory.create(
      { "error": {} },
      401
    )

    assert_equal "Error 401: You did not supply valid authentication credentials.", error.message
  end

  def test_twitch_error_generator_message
    error = Twitch::ErrorGenerator.new({ "error" => 123, "message" => "Twitch error message" }, 409)

    assert_equal "Twitch error message", error.twitch_error_message
  end

  def test_twitch_error_message
    error = Twitch::Error.new("Connection failed")

    assert_equal "Connection failed", error.message
  end
end
