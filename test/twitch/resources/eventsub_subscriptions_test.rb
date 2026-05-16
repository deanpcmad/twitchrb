require "test_helper"

class EventsubSubscriptionsResourceTest < Minitest::Test
  def test_eventsub_subscriptions_list_with_user_token
    setup_client
    subscriptions = @client.eventsub_subscriptions.list

    assert_equal Twitch::Collection, subscriptions.class
    assert subscriptions.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_app_token
    app_client = setup_app_client
    skip "Could not create app client" unless app_client

    subscriptions = app_client.eventsub_subscriptions.list

    assert_equal Twitch::Collection, subscriptions.class
    assert subscriptions.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_status
    setup_client
    subscriptions = @client.eventsub_subscriptions.list(status: "enabled")

    assert_equal Twitch::Collection, subscriptions.class
    assert subscriptions.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_type
    setup_client
    subscriptions = @client.eventsub_subscriptions.list(type: "channel.update")

    assert_equal Twitch::Collection, subscriptions.class
    assert subscriptions.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_user_id
    setup_client
    subscriptions = @client.eventsub_subscriptions.list(user_id: "141981764")

    assert_equal Twitch::Collection, subscriptions.class
    assert subscriptions.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_conduit_id
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/eventsub/subscriptions") do |env|
        assert_equal({ "conduit_id" => "conduit-123" }, env.params)

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            total: 1,
            data: [
              {
                id: "sub-1",
                status: "enabled",
                type: "channel.chat.message",
                version: "1",
                condition: { broadcaster_user_id: "123", user_id: "321" },
                transport: { method: "conduit", conduit_id: "conduit-123" },
                cost: 0,
                created_at: "2026-04-17T12:00:00Z"
              }
            ],
            pagination: {}
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    subscriptions = client.eventsub_subscriptions.list(conduit_id: "conduit-123")

    assert_equal Twitch::Collection, subscriptions.class
    assert_equal "sub-1", subscriptions.first.id
  end

  def test_eventsub_subscriptions_list_with_pagination
    setup_client

    first_page = @client.eventsub_subscriptions.list(first: 5)

    if first_page.cursor
      subscriptions = @client.eventsub_subscriptions.list(first: 5, after: first_page.cursor)

      assert_equal Twitch::Collection, subscriptions.class
      assert subscriptions.data.count <= 5
      assert subscriptions.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
    else
      assert_equal Twitch::Collection, first_page.class
      assert first_page.data.count <= 5
      assert first_page.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
    end
  end

  def test_eventsub_subscriptions_create_webhook_with_user_token_fails
    setup_client

    assert_raises(Twitch::Errors::BadRequestError) do
      @client.eventsub_subscriptions.create(
        type: "channel.update",
        version: "1",
        condition: {
          broadcaster_user_id: "141981764"
        },
        transport: {
          method: "webhook",
          callback: "https://example.com/webhooks/callback",
          secret: "secretkey123"
        }
      )
    end
  end

  def test_eventsub_subscriptions_create_webhook_with_app_token
    app_client = setup_app_client
    skip "Could not create app client" unless app_client

    subscription = app_client.eventsub_subscriptions.create(
      type: "channel.update",
      version: "1",
      condition: {
        broadcaster_user_id: "141981764"
      },
      transport: {
        method: "webhook",
        callback: "https://example.com/webhooks/callback",
        secret: "secretkey123"
      }
    )

    if subscription
      assert_equal Twitch::EventsubSubscription, subscription.class
      refute_nil subscription.id
      assert_equal "channel.update", subscription.type
      assert_equal "1", subscription.version
    end
  end

  def test_eventsub_subscriptions_create_websocket_requires_valid_session
    setup_client

    assert_raises(Twitch::Errors::BadRequestError) do
      @client.eventsub_subscriptions.create(
        type: "channel.update",
        version: "1",
        condition: {
          broadcaster_user_id: "141981764"
        },
        transport: {
          method: "websocket",
          session_id: "invalid-session-id"
        }
      )
    end
  end

  def test_eventsub_subscriptions_delete
    setup_client

    # First try to get an existing subscription to delete
    subscriptions = @client.eventsub_subscriptions.list(first: 1)

    if subscriptions.data.any?
      subscription_id = subscriptions.data.first.id
      response = @client.eventsub_subscriptions.delete(id: subscription_id)

      assert_respond_to response, :status
    else
      # Test with a mock ID to verify the endpoint works (expect 404 for non-existent)
      assert_raises(Twitch::Errors::EntityNotFoundError) do
        @client.eventsub_subscriptions.delete(id: "non-existent-id")
      end
    end
  end

  def test_eventsub_subscriptions_create_invalid_transport_raises_error
    setup_client

    assert_raises(Twitch::Errors::BadRequestError) do
      @client.eventsub_subscriptions.create(
        type: "channel.update",
        version: "1",
        condition: {
          broadcaster_user_id: "141981764"
        },
        transport: {
          method: "invalid_method"
        }
      )
    end
  end

  def test_eventsub_subscriptions_create_conflict_exposes_existing_subscription_id
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("https://api.twitch.tv/helix/eventsub/subscriptions") do |_env|
        [
          409,
          { "content-type" => "application/json" },
          JSON.dump(
            error: "Conflict",
            status: 409,
            message: "subscription already exists",
            data: [
              { id: "existing-subscription-id" }
            ]
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    error = assert_raises(Twitch::Errors::EventsubSubscriptionConflictError) do
      client.eventsub_subscriptions.create(
        type: "channel.update",
        version: "1",
        condition: {
          broadcaster_user_id: "141981764"
        },
        transport: {
          method: "webhook",
          callback: "https://example.com/webhooks/callback",
          secret: "secretkey123"
        }
      )
    end

    assert_equal "existing-subscription-id", error.existing_subscription_id
    assert_equal "subscription already exists", error.twitch_error_message
  end
end
