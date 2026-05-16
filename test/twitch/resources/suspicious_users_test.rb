require "test_helper"

class SuspiciousUsersResourceTest < Minitest::Test
  def test_suspicious_users_create_returns_object
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("https://api.twitch.tv/helix/moderation/suspicious_users") do |env|
        assert_equal(
          { "broadcaster_id" => "123", "moderator_id" => "321" },
          env.params
        )

        body = JSON.parse(env.body)
        assert_equal "9876", body["user_id"]
        assert_equal "RESTRICTED", body["status"]

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            data: [
              {
                user_id: "9876",
                broadcaster_id: "123",
                moderator_id: "321",
                updated_at: "2025-12-01T23:08:18+00:00",
                status: "RESTRICTED",
                types: [ "MANUALLY_ADDED" ]
              }
            ]
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    user = client.suspicious_users.create(
      broadcaster_id: "123",
      moderator_id: "321",
      user_id: "9876",
      status: "RESTRICTED"
    )

    assert_instance_of Twitch::SuspiciousUser, user
    assert_equal "9876", user.user_id
    assert_equal "RESTRICTED", user.status
    assert_equal "MANUALLY_ADDED", user.types.first
  end

  def test_suspicious_users_delete_returns_object
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.delete("https://api.twitch.tv/helix/moderation/suspicious_users") do |env|
        assert_equal(
          {
            "broadcaster_id" => "123",
            "moderator_id" => "321",
            "user_id" => "9876"
          },
          env.params
        )

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            data: [
              {
                user_id: "9876",
                broadcaster_id: "123",
                moderator_id: "321",
                updated_at: "2025-12-01T23:08:18+00:00",
                status: "NO_TREATMENT",
                types: [ "MANUALLY_ADDED" ]
              }
            ]
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    user = client.suspicious_users.delete(
      broadcaster_id: "123",
      moderator_id: "321",
      user_id: "9876"
    )

    assert_instance_of Twitch::SuspiciousUser, user
    assert_equal "9876", user.user_id
    assert_equal "NO_TREATMENT", user.status
  end
end
