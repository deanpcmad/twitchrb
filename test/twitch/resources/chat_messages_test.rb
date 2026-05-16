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

  def test_chat_messages_create_supports_for_source_only
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("https://api.twitch.tv/helix/chat/messages") do |env|
        body = JSON.parse(env.body)
        assert_equal "123", body["broadcaster_id"]
        assert_equal "321", body["sender_id"]
        assert_equal "Shared chat message", body["message"]
        assert_equal false, body["for_source_only"]

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            {
              data: [
                {
                  message_id: "msg-2",
                  is_sent: true,
                  is_source_only: false,
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
      message: "Shared chat message",
      for_source_only: false
    )

    assert_instance_of Twitch::ChatMessage, message
    assert_equal "msg-2", message.message_id
    assert_equal false, message.is_source_only
  end
end
