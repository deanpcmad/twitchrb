require "test_helper"

class EventsubConduitsResourceTest < WebmockTest
  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_user_token")
    @app_client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_app_token")
  end

  def test_eventsub_conduits_list_with_user_token_fails
    stub_request(:get, "#{HELIX_URL}/eventsub/conduits")
      .to_return(status: 401, body: unauthorized_body, headers: json_headers)

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.eventsub_conduits.list
    end
  end

  def test_eventsub_conduits_list_with_app_token
    stub_request(:get, "#{HELIX_URL}/eventsub/conduits")
      .to_return(status: 200, body: helix_fixture("get_conduits"), headers: json_headers)

    conduits = @app_client.eventsub_conduits.list

    assert_equal Twitch::Collection, conduits.class
    assert conduits.data.all? { |conduit| conduit.is_a?(Twitch::EventsubConduit) }
  end

  def test_eventsub_conduits_create_with_user_token_fails
    stub_request(:post, "#{HELIX_URL}/eventsub/conduits")
      .to_return(status: 401, body: unauthorized_body, headers: json_headers)

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.eventsub_conduits.create(shard_count: 1)
    end
  end

  def test_eventsub_conduits_create_with_app_token
    conduit_id = "26b1c993-bfcf-44d9-b876-379dacafe75a"

    stub_request(:post, "#{HELIX_URL}/eventsub/conduits")
      .with(body: hash_including("shard_count" => 1))
      .to_return(
        status: 200,
        body: { data: [ { id: conduit_id, shard_count: 1 } ] }.to_json,
        headers: json_headers
      )

    stub_request(:delete, "#{HELIX_URL}/eventsub/conduits")
      .with(query: { "id" => conduit_id })
      .to_return(status: 204, body: "")

    conduit = @app_client.eventsub_conduits.create(shard_count: 1)

    assert_equal Twitch::EventsubConduit, conduit.class
    assert_equal conduit_id, conduit.id
    assert_equal 1, conduit.shard_count

    @app_client.eventsub_conduits.delete(id: conduit.id)
  end

  def test_eventsub_conduits_create_and_manage_lifecycle_with_app_token
    conduit_id = "26b1c993-bfcf-44d9-b876-379dacafe75a"

    stub_request(:post, "#{HELIX_URL}/eventsub/conduits")
      .with(body: hash_including("shard_count" => 2))
      .to_return(
        status: 200,
        body: { data: [ { id: conduit_id, shard_count: 2 } ] }.to_json,
        headers: json_headers
      )

    stub_request(:get, "#{HELIX_URL}/eventsub/conduits/shards")
      .with(query: { "conduit_id" => conduit_id })
      .to_return(status: 200, body: helix_fixture("get_conduit_shards"), headers: json_headers)

    stub_request(:patch, "#{HELIX_URL}/eventsub/conduits")
      .with(body: hash_including("id" => conduit_id, "shard_count" => 3))
      .to_return(
        status: 200,
        body: { data: [ { id: conduit_id, shard_count: 3 } ] }.to_json,
        headers: json_headers
      )

    stub_request(:delete, "#{HELIX_URL}/eventsub/conduits")
      .with(query: { "id" => conduit_id })
      .to_return(status: 204, body: "")

    conduit = @app_client.eventsub_conduits.create(shard_count: 2)
    assert_equal 2, conduit.shard_count

    shards = @app_client.eventsub_conduits.shards(id: conduit.id)
    assert_equal Twitch::Collection, shards.class
    assert shards.data.all? { |shard| shard.is_a?(Twitch::EventsubConduitShard) }

    updated = @app_client.eventsub_conduits.update(id: conduit.id, shard_count: 3)
    assert_equal 3, updated.shard_count

    @app_client.eventsub_conduits.delete(id: conduit.id)
  end

  def test_eventsub_conduits_operations_with_user_token_fail
    stub_request(:post, "#{HELIX_URL}/eventsub/conduits")
      .to_return(status: 401, body: unauthorized_body, headers: json_headers)
    stub_request(:patch, "#{HELIX_URL}/eventsub/conduits")
      .to_return(status: 401, body: unauthorized_body, headers: json_headers)
    stub_request(:get, %r{#{HELIX_URL}/eventsub/conduits/shards})
      .to_return(status: 401, body: unauthorized_body, headers: json_headers)
    stub_request(:delete, %r{#{HELIX_URL}/eventsub/conduits\?})
      .to_return(status: 401, body: unauthorized_body, headers: json_headers)

    assert_raises(Twitch::Errors::AuthenticationMissingError) { @client.eventsub_conduits.create(shard_count: 3) }
    assert_raises(Twitch::Errors::AuthenticationMissingError) { @client.eventsub_conduits.update(id: "fake-id", shard_count: 2) }
    assert_raises(Twitch::Errors::AuthenticationMissingError) { @client.eventsub_conduits.shards(id: "fake-id") }
    assert_raises(Twitch::Errors::AuthenticationMissingError) { @client.eventsub_conduits.delete(id: "fake-id") }
  end

  private

  def json_headers
    { "Content-Type" => "application/json" }
  end

  def unauthorized_body
    { error: "Unauthorized", status: 401, message: "OAuth token is missing" }.to_json
  end
end
