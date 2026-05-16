require "test_helper"

class PinnedChatMessagesResourceTest < Minitest::Test
  def test_pinned_chat_messages_retrieve_returns_object
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/chat/pins") do |env|
        assert_equal({ "broadcaster_id" => "123", "moderator_id" => "321" }, env.params)

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            {
            data: [
              {
                id: "pin-1",
                message_id: "msg-1",
                broadcaster_id: "123",
                moderator_id: "321",
                fragments: [
                  { type: "text", text: "Pinned message" }
                ]
              }
            ]
            }
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    pinned_message = client.pinned_chat_messages.retrieve(broadcaster_id: "123", moderator_id: "321")

    assert_instance_of Twitch::PinnedChatMessage, pinned_message
    assert_equal "pin-1", pinned_message.id
    assert_equal "Pinned message", pinned_message.fragments.first.text
  end

  def test_pinned_chat_messages_retrieve_returns_nil_when_none_exist
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/chat/pins") do
        [ 200, { "content-type" => "application/json" }, JSON.dump(data: []) ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    assert_nil client.pinned_chat_messages.retrieve(broadcaster_id: "123", moderator_id: "321")
  end

  def test_pinned_chat_messages_create_uses_query_params
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.put("https://api.twitch.tv/helix/chat/pins") do |env|
        assert_equal(
          {
            "broadcaster_id" => "123",
            "moderator_id" => "321",
            "message_id" => "msg-1",
            "duration_seconds" => "90"
          },
          env.params
        )
        assert_equal "{}", env.body

        [ 204, {}, "" ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    assert client.pinned_chat_messages.create(
      broadcaster_id: "123",
      moderator_id: "321",
      message_id: "msg-1",
      duration_seconds: 90
    )
  end

  def test_pinned_chat_messages_update_uses_query_params
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.patch("https://api.twitch.tv/helix/chat/pins") do |env|
        assert_equal(
          {
            "broadcaster_id" => "123",
            "moderator_id" => "321",
            "message_id" => "msg-1",
            "duration_seconds" => "120"
          },
          env.params
        )
        assert_equal "{}", env.body

        [ 204, {}, "" ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    assert client.pinned_chat_messages.update(
      broadcaster_id: "123",
      moderator_id: "321",
      message_id: "msg-1",
      duration_seconds: 120
    )
  end

  def test_pinned_chat_messages_delete_uses_query_params
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.delete("https://api.twitch.tv/helix/chat/pins") do |env|
        assert_equal(
          {
            "broadcaster_id" => "123",
            "moderator_id" => "321",
            "message_id" => "msg-1"
          },
          env.params
        )

        [ 204, {}, "" ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    assert client.pinned_chat_messages.delete(broadcaster_id: "123", moderator_id: "321", message_id: "msg-1")
  end
end
