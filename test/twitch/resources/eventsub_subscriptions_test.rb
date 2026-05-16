require "test_helper"

class EventsubSubscriptionsResourceTest < WebmockTest
  SUBS_URL = "#{HELIX_URL}/eventsub/subscriptions".freeze

  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_user_token")
    @app_client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_app_token")
  end

  def test_eventsub_subscriptions_list_with_user_token
    stub_request(:get, SUBS_URL)
      .to_return(status: 200, body: helix_fixture("get_eventsub_subscriptions"), headers: json_headers)

    subs = @client.eventsub_subscriptions.list

    assert_equal Twitch::Collection, subs.class
    assert subs.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_app_token
    stub_request(:get, SUBS_URL)
      .to_return(status: 200, body: helix_fixture("get_eventsub_subscriptions"), headers: json_headers)

    subs = @app_client.eventsub_subscriptions.list

    assert_equal Twitch::Collection, subs.class
    assert subs.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_status
    stub_request(:get, SUBS_URL)
      .with(query: { "status" => "enabled" })
      .to_return(status: 200, body: helix_fixture("get_eventsub_subscriptions"), headers: json_headers)

    subs = @client.eventsub_subscriptions.list(status: "enabled")

    assert_equal Twitch::Collection, subs.class
    assert subs.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_type
    stub_request(:get, SUBS_URL)
      .with(query: { "type" => "channel.update" })
      .to_return(status: 200, body: helix_fixture("get_eventsub_subscriptions"), headers: json_headers)

    subs = @client.eventsub_subscriptions.list(type: "channel.update")

    assert_equal Twitch::Collection, subs.class
    assert subs.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_user_id
    stub_request(:get, SUBS_URL)
      .with(query: { "user_id" => "141981764" })
      .to_return(status: 200, body: helix_fixture("get_eventsub_subscriptions"), headers: json_headers)

    subs = @client.eventsub_subscriptions.list(user_id: "141981764")

    assert_equal Twitch::Collection, subs.class
    assert subs.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_list_with_conduit_id
    stub_request(:get, SUBS_URL)
      .with(query: { "conduit_id" => "conduit-123" })
      .to_return(
        status: 200,
        body: {
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
        }.to_json,
        headers: json_headers
      )

    subs = @client.eventsub_subscriptions.list(conduit_id: "conduit-123")

    assert_equal Twitch::Collection, subs.class
    assert_equal "sub-1", subs.first.id
  end

  def test_eventsub_subscriptions_list_with_pagination
    stub_request(:get, SUBS_URL)
      .with(query: { "first" => "5" })
      .to_return(status: 200, body: helix_fixture("get_eventsub_subscriptions"), headers: json_headers)

    stub_request(:get, SUBS_URL)
      .with(query: { "first" => "5", "after" => "eyJiIjpudWxsLCJhIjp7Ik9mZnNldCI6MX19" })
      .to_return(status: 200, body: helix_fixture("get_eventsub_subscriptions"), headers: json_headers)

    first_page = @client.eventsub_subscriptions.list(first: 5)
    assert first_page.cursor, "expected pagination cursor in fixture"

    page2 = @client.eventsub_subscriptions.list(first: 5, after: first_page.cursor)
    assert_equal Twitch::Collection, page2.class
    assert page2.data.all? { |sub| sub.is_a?(Twitch::EventsubSubscription) }
  end

  def test_eventsub_subscriptions_create_webhook_with_user_token_fails
    stub_request(:post, SUBS_URL)
      .to_return(
        status: 400,
        body: { error: "Bad Request", status: 400, message: "webhook transport requires app token" }.to_json,
        headers: json_headers
      )

    assert_raises(Twitch::Errors::BadRequestError) do
      @client.eventsub_subscriptions.create(
        type: "channel.update",
        version: "1",
        condition: { broadcaster_user_id: "141981764" },
        transport: { method: "webhook", callback: "https://example.com/webhooks/callback", secret: "secretkey123" }
      )
    end
  end

  def test_eventsub_subscriptions_create_webhook_with_app_token
    stub_request(:post, SUBS_URL)
      .with(body: hash_including("type" => "channel.update", "version" => "1"))
      .to_return(
        status: 202,
        body: {
          data: [
            {
              id: "new-sub-id",
              status: "webhook_callback_verification_pending",
              type: "channel.update",
              version: "1",
              condition: { broadcaster_user_id: "141981764" },
              created_at: "2025-04-10T12:00:00Z",
              transport: { method: "webhook", callback: "https://example.com/webhooks/callback" },
              cost: 1
            }
          ],
          total: 1,
          total_cost: 1,
          max_total_cost: 10000
        }.to_json,
        headers: json_headers
      )

    subscription = @app_client.eventsub_subscriptions.create(
      type: "channel.update",
      version: "1",
      condition: { broadcaster_user_id: "141981764" },
      transport: { method: "webhook", callback: "https://example.com/webhooks/callback", secret: "secretkey123" }
    )

    assert_equal Twitch::EventsubSubscription, subscription.class
    assert_equal "new-sub-id", subscription.id
    assert_equal "channel.update", subscription.type
    assert_equal "1", subscription.version
  end

  def test_eventsub_subscriptions_create_websocket_requires_valid_session
    stub_request(:post, SUBS_URL)
      .to_return(
        status: 400,
        body: { error: "Bad Request", status: 400, message: "invalid websocket session id" }.to_json,
        headers: json_headers
      )

    assert_raises(Twitch::Errors::BadRequestError) do
      @client.eventsub_subscriptions.create(
        type: "channel.update",
        version: "1",
        condition: { broadcaster_user_id: "141981764" },
        transport: { method: "websocket", session_id: "invalid-session-id" }
      )
    end
  end

  def test_eventsub_subscriptions_delete
    stub_request(:delete, SUBS_URL)
      .with(query: { "id" => "non-existent-id" })
      .to_return(
        status: 404,
        body: { error: "Not Found", status: 404, message: "subscription not found" }.to_json,
        headers: json_headers
      )

    assert_raises(Twitch::Errors::EntityNotFoundError) do
      @client.eventsub_subscriptions.delete(id: "non-existent-id")
    end
  end

  def test_eventsub_subscriptions_create_invalid_transport_raises_error
    stub_request(:post, SUBS_URL)
      .to_return(
        status: 400,
        body: { error: "Bad Request", status: 400, message: "transport method must be webhook, websocket, or conduit" }.to_json,
        headers: json_headers
      )

    assert_raises(Twitch::Errors::BadRequestError) do
      @client.eventsub_subscriptions.create(
        type: "channel.update",
        version: "1",
        condition: { broadcaster_user_id: "141981764" },
        transport: { method: "invalid_method" }
      )
    end
  end

  def test_eventsub_subscriptions_create_conflict_exposes_existing_subscription_id
    stub_request(:post, SUBS_URL)
      .to_return(
        status: 409,
        body: {
          error: "Conflict",
          status: 409,
          message: "subscription already exists",
          data: [ { id: "existing-subscription-id" } ]
        }.to_json,
        headers: json_headers
      )

    error = assert_raises(Twitch::Errors::EventsubSubscriptionConflictError) do
      @client.eventsub_subscriptions.create(
        type: "channel.update",
        version: "1",
        condition: { broadcaster_user_id: "141981764" },
        transport: { method: "webhook", callback: "https://example.com/webhooks/callback", secret: "secretkey123" }
      )
    end

    assert_equal "existing-subscription-id", error.existing_subscription_id
    assert_equal "subscription already exists", error.twitch_error_message
  end

  private

  def json_headers
    { "Content-Type" => "application/json" }
  end
end
