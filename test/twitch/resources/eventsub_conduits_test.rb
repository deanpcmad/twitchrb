require "test_helper"

class EventsubConduitsResourceTest < Minitest::Test
  def test_eventsub_conduits_list_with_user_token_fails
    setup_client

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.eventsub_conduits.list
    end
  end

  def test_eventsub_conduits_list_with_app_token
    app_client = setup_app_client
    skip "Could not create app client" unless app_client

    conduits = app_client.eventsub_conduits.list

    assert_equal Twitch::Collection, conduits.class
    assert conduits.data.all? { |conduit| conduit.is_a?(Twitch::EventsubConduit) }
  end

  def test_eventsub_conduits_create_with_user_token_fails
    setup_client

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.eventsub_conduits.create(shard_count: 1)
    end
  end

  def test_eventsub_conduits_create_with_app_token
    app_client = setup_app_client
    skip "Could not create app client" unless app_client

    conduit = app_client.eventsub_conduits.create(shard_count: 1)

    if conduit
      assert_equal Twitch::EventsubConduit, conduit.class
      assert_not_nil conduit.id
      assert_equal 1, conduit.shard_count

      # Clean up - delete the conduit
      app_client.eventsub_conduits.delete(id: conduit.id)
    end
  end

  def test_eventsub_conduits_create_and_manage_lifecycle_with_app_token
    app_client = setup_app_client
    skip "Could not create app client" unless app_client

    # Create conduit with multiple shards
    conduit = app_client.eventsub_conduits.create(shard_count: 2)
    skip "Could not create conduit" unless conduit

    assert_equal Twitch::EventsubConduit, conduit.class
    assert_equal 2, conduit.shard_count

    # Test getting shards
    shards = app_client.eventsub_conduits.shards(id: conduit.id)
    assert_equal Twitch::Collection, shards.class
    assert shards.data.all? { |shard| shard.is_a?(Twitch::EventsubConduitShard) }

    # Test updating conduit
    updated_conduit = app_client.eventsub_conduits.update(id: conduit.id, shard_count: 3)
    if updated_conduit
      assert_equal 3, updated_conduit.shard_count
    end

    # Clean up - delete the conduit
    app_client.eventsub_conduits.delete(id: conduit.id)
  end

  def test_eventsub_conduits_operations_with_user_token_fail
    setup_client

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.eventsub_conduits.create(shard_count: 3)
    end

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.eventsub_conduits.update(id: "fake-id", shard_count: 2)
    end

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.eventsub_conduits.shards(id: "fake-id")
    end

    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.eventsub_conduits.delete(id: "fake-id")
    end
  end
end
