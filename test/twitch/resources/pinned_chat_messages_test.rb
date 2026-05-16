require "test_helper"

class PinnedChatMessagesResourceTest < WebmockTest
  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_token")
  end

  def test_pinned_chat_messages_retrieve_returns_object
    stub_request(:get, "#{HELIX_URL}/chat/pins")
      .with(query: { "broadcaster_id" => "123", "moderator_id" => "321" })
      .to_return(
        status: 200,
        body: {
          data: [
            {
              id: "pin-1",
              message_id: "msg-1",
              broadcaster_id: "123",
              moderator_id: "321",
              fragments: [ { type: "text", text: "Pinned message" } ]
            }
          ]
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    pinned = @client.pinned_chat_messages.retrieve(broadcaster_id: "123", moderator_id: "321")

    assert_instance_of Twitch::PinnedChatMessage, pinned
    assert_equal "pin-1", pinned.id
    assert_equal "Pinned message", pinned.fragments.first.text
  end

  def test_pinned_chat_messages_retrieve_returns_nil_when_none_exist
    stub_request(:get, "#{HELIX_URL}/chat/pins")
      .with(query: { "broadcaster_id" => "123", "moderator_id" => "321" })
      .to_return(status: 200, body: { data: [] }.to_json,
        headers: { "Content-Type" => "application/json" })

    assert_nil @client.pinned_chat_messages.retrieve(broadcaster_id: "123", moderator_id: "321")
  end

  def test_pinned_chat_messages_create_uses_query_params
    stub_request(:put, "#{HELIX_URL}/chat/pins")
      .with(query: {
        "broadcaster_id" => "123",
        "moderator_id" => "321",
        "message_id" => "msg-1",
        "duration_seconds" => "90"
      })
      .to_return(status: 204, body: "")

    assert @client.pinned_chat_messages.create(
      broadcaster_id: "123",
      moderator_id: "321",
      message_id: "msg-1",
      duration_seconds: 90
    )
  end

  def test_pinned_chat_messages_update_uses_query_params
    stub_request(:patch, "#{HELIX_URL}/chat/pins")
      .with(query: {
        "broadcaster_id" => "123",
        "moderator_id" => "321",
        "message_id" => "msg-1",
        "duration_seconds" => "120"
      })
      .to_return(status: 204, body: "")

    assert @client.pinned_chat_messages.update(
      broadcaster_id: "123",
      moderator_id: "321",
      message_id: "msg-1",
      duration_seconds: 120
    )
  end

  def test_pinned_chat_messages_delete_uses_query_params
    stub_request(:delete, "#{HELIX_URL}/chat/pins")
      .with(query: { "broadcaster_id" => "123", "moderator_id" => "321", "message_id" => "msg-1" })
      .to_return(status: 204, body: "")

    assert @client.pinned_chat_messages.delete(
      broadcaster_id: "123",
      moderator_id: "321",
      message_id: "msg-1"
    )
  end
end
