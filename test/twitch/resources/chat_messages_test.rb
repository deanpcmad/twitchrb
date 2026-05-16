require "test_helper"

class ChatMessagesResourceTest < WebmockTest
  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_token")
  end

  def test_chat_messages_create_supports_pin
    stub_request(:post, "#{HELIX_URL}/chat/messages")
      .with(body: hash_including(
        "broadcaster_id" => "123",
        "sender_id" => "321",
        "message" => "Pinned message",
        "pin" => true
      ))
      .to_return(
        status: 200,
        body: { data: [ { message_id: "msg-1", is_sent: true, drop_reason: nil } ] }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    message = @client.chat_messages.create(
      broadcaster_id: "123",
      sender_id: "321",
      message: "Pinned message",
      pin: true
    )

    assert_instance_of Twitch::ChatMessage, message
    assert_equal "msg-1", message.message_id
  end

  def test_chat_messages_create_supports_for_source_only
    stub_request(:post, "#{HELIX_URL}/chat/messages")
      .with(body: hash_including(
        "broadcaster_id" => "123",
        "sender_id" => "321",
        "message" => "Shared chat message",
        "for_source_only" => false
      ))
      .to_return(
        status: 200,
        body: {
          data: [ { message_id: "msg-2", is_sent: true, is_source_only: false, drop_reason: nil } ]
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    message = @client.chat_messages.create(
      broadcaster_id: "123",
      sender_id: "321",
      message: "Shared chat message",
      for_source_only: false
    )

    assert_instance_of Twitch::ChatMessage, message
    assert_equal "msg-2", message.message_id
    assert_equal false, message.is_source_only
  end
end
