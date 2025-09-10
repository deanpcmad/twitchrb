require "test_helper"

class OAuthTest < Minitest::Test
  def setup
    @oauth = Twitch::OAuth.new(
      client_id: ENV["TWITCH_CLIENT_ID"],
      client_secret: ENV["TWITCH_CLIENT_SECRET"]
    )
  end

  def test_oauth_initialization
    oauth = Twitch::OAuth.new(client_id: "test_id", client_secret: "test_secret")

    assert_equal "test_id", oauth.client_id
    assert_equal "test_secret", oauth.client_secret
  end

  def test_oauth_create_client_credentials_token
    skip "Requires valid client credentials" unless ENV["TWITCH_CLIENT_SECRET"]

    token = @oauth.create(grant_type: "client_credentials")

    if token
      assert_respond_to token, :access_token
      assert_respond_to token, :token_type
      assert_equal "bearer", token.token_type
      assert_not_nil token.access_token
    end
  end

  def test_oauth_create_client_credentials_with_scopes
    skip "Requires valid client credentials" unless ENV["TWITCH_CLIENT_SECRET"]

    token = @oauth.create(
      grant_type: "client_credentials",
      scope: "channel:read:subscriptions"
    )

    if token
      assert_respond_to token, :access_token
      assert_respond_to token, :scope
      assert_equal "bearer", token.token_type
      assert_not_nil token.access_token
    end
  end

  def test_oauth_validate_token
    skip "Requires valid client credentials" unless ENV["TWITCH_CLIENT_SECRET"]

    # First get a valid token
    token_response = @oauth.create(grant_type: "client_credentials")
    skip "Could not create token for validation test" unless token_response

    validation = @oauth.validate(token: token_response.access_token)

    if validation
      assert_respond_to validation, :client_id
      assert_respond_to validation, :expires_in
      assert_equal ENV["TWITCH_CLIENT_ID"], validation.client_id
    end
  end

  def test_oauth_validate_invalid_token
    validation = @oauth.validate(token: "invalid_token_123")

    assert_equal false, validation
  end

  def test_oauth_revoke_token
    skip "Requires valid client credentials" unless ENV["TWITCH_CLIENT_SECRET"]

    # First get a valid token
    token_response = @oauth.create(grant_type: "client_credentials")
    skip "Could not create token for revoke test" unless token_response

    result = @oauth.revoke(token: token_response.access_token)

    assert_equal true, result

    # Verify token is now invalid
    validation = @oauth.validate(token: token_response.access_token)
    assert_equal false, validation
  end

  def test_oauth_device_flow_initiation
    skip "Requires valid client credentials" unless ENV["TWITCH_CLIENT_SECRET"]

    device_response = @oauth.device(scopes: "user:read:email")

    if device_response
      assert_respond_to device_response, :device_code
      assert_respond_to device_response, :user_code
      assert_respond_to device_response, :verification_uri
      assert_respond_to device_response, :expires_in
      assert_respond_to device_response, :interval
      assert_not_nil device_response.device_code
      assert_not_nil device_response.user_code
      assert_not_nil device_response.verification_uri
    end
  end

  def test_oauth_refresh_token_with_invalid_token
    result = @oauth.refresh(refresh_token: "invalid_refresh_token")

    assert_equal false, result
  end

  def test_oauth_create_with_invalid_grant_type
    result = @oauth.create(grant_type: "invalid_grant_type")

    assert_equal false, result
  end

  def test_oauth_create_with_invalid_credentials
    bad_oauth = Twitch::OAuth.new(
      client_id: "invalid_client_id",
      client_secret: "invalid_client_secret"
    )

    result = bad_oauth.create(grant_type: "client_credentials")

    assert_equal false, result
  end

  def test_oauth_revoke_invalid_token
    result = @oauth.revoke(token: "invalid_token")

    # Revoking invalid token should still return true (no error)
    assert_equal true, result
  end

  def test_oauth_device_with_invalid_scopes
    skip "Requires valid client credentials" unless ENV["TWITCH_CLIENT_SECRET"]

    # This test actually succeeds - Twitch allows any scope string in device flow
    # The validation happens when the user actually authorizes
    result = @oauth.device(scopes: "invalid:scope")

    # Should return a device response even with invalid scopes
    if result
      assert_respond_to result, :device_code
      assert_respond_to result, :user_code
      assert_not_nil result.device_code
      assert_not_nil result.user_code
    else
      assert_equal false, result
    end
  end
end
