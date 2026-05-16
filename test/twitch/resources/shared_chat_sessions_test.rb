require "test_helper"

class SharedChatSessionsResourceTest < WebmockTest
  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_token")
  end

  def test_shared_chat_sessions_retrieve_returns_object
    stub_request(:get, "#{HELIX_URL}/shared_chat/session")
      .with(query: { "broadcaster_id" => "123" })
      .to_return(
        status: 200,
        body: {
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
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    session = @client.shared_chat_sessions.retrieve(broadcaster_id: "123")

    assert_instance_of Twitch::SharedChatSession, session
    assert_equal "session-1", session.session_id
    assert_equal "456", session.participants.last.broadcaster_id
  end

  def test_shared_chat_sessions_retrieve_returns_nil_when_none_exist
    stub_request(:get, "#{HELIX_URL}/shared_chat/session")
      .with(query: { "broadcaster_id" => "123" })
      .to_return(status: 200, body: { data: [] }.to_json,
        headers: { "Content-Type" => "application/json" })

    assert_nil @client.shared_chat_sessions.retrieve(broadcaster_id: "123")
  end
end
