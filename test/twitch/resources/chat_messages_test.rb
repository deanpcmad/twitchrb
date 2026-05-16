require "test_helper"

class ChatMessagesResourceTest < Minitest::Test
  def test_chat_messages_create_supports_pin
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("https://api.twitch.tv/helix/chat/messages") do |env|
        body = JSON.parse(env.body)
        assert_equal "123", body["broadcaster_id"]
        assert_equal "321", body["sender_id"]
        assert_equal "Pinned message", body["message"]
        assert_equal true, body["pin"]

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            {
            data: [
              {
                message_id: "msg-1",
                is_sent: true,
                drop_reason: nil
              }
            ]
            }
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    message = client.chat_messages.create(
      broadcaster_id: "123",
      sender_id: "321",
      message: "Pinned message",
      pin: true
    )

    assert_instance_of Twitch::ChatMessage, message
    assert_equal "msg-1", message.message_id
  end
end
