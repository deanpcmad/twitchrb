require "test_helper"

class SharedChatSessionsResourceTest < Minitest::Test
  def test_shared_chat_sessions_retrieve_returns_object
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/shared_chat/session") do |env|
        assert_equal({ "broadcaster_id" => "123" }, env.params)

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            data: [
              {
                session_id: "session-1",
                host_broadcaster_id: "123",
                participants: [
                  { broadcaster_id: "123" },
                  { broadcaster_id: "456" }
                ],
                created_at: "2025-04-10T12:00:00Z",
                updated_at: "2025-04-10T12:05:00Z"
              }
            ]
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    session = client.shared_chat_sessions.retrieve(broadcaster_id: "123")

    assert_instance_of Twitch::SharedChatSession, session
    assert_equal "session-1", session.session_id
    assert_equal "456", session.participants.last.broadcaster_id
  end

  def test_shared_chat_sessions_retrieve_returns_nil_when_none_exist
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/shared_chat/session") do
        [ 200, { "content-type" => "application/json" }, JSON.dump(data: []) ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    assert_nil client.shared_chat_sessions.retrieve(broadcaster_id: "123")
  end
end
