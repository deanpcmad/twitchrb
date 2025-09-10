require "test_helper"

class ClipsResourceTest < Minitest::Test
  def test_clips_list_by_broadcaster_id
    setup_client
    clips = @client.clips.list(broadcaster_id: "141981764", first: 5)

    assert_equal Twitch::Collection, clips.class
    assert clips.data.count <= 5
    assert clips.data.all? { |clip| clip.is_a?(Twitch::Clip) }
  end

  def test_clips_list_by_game_id
    setup_client
    clips = @client.clips.list(game_id: "33214", first: 3)

    assert_equal Twitch::Collection, clips.class
    assert clips.data.count <= 3
    assert clips.data.all? { |clip| clip.is_a?(Twitch::Clip) }
  end

  def test_clips_list_with_date_range
    setup_client
    started_at = "2023-01-01T00:00:00Z"
    ended_at = "2023-12-31T23:59:59Z"
    
    clips = @client.clips.list(
      broadcaster_id: "141981764",
      started_at: started_at,
      ended_at: ended_at,
      first: 5
    )

    assert_equal Twitch::Collection, clips.class
    assert clips.data.count <= 5
    assert clips.data.all? { |clip| clip.is_a?(Twitch::Clip) }
  end

  def test_clips_list_missing_params_raises_error
    setup_client
    
    assert_raises(RuntimeError) do
      @client.clips.list(first: 5)
    end
  end

  def test_clips_retrieve
    setup_client
    
    # First get a real clip ID from the clips list
    clips = @client.clips.list(broadcaster_id: "141981764", first: 1)
    
    if clips.data.any?
      clip_id = clips.data.first.id
      clip = @client.clips.retrieve(id: clip_id)
      
      assert_equal Twitch::Clip, clip.class
      assert_equal clip_id, clip.id
    else
      # Skip test if no clips available
      skip "No clips available for broadcaster"
    end
  end

  def test_clips_create_requires_scope
    setup_client
    
    assert_raises(Twitch::Errors::AuthenticationMissingError) do
      @client.clips.create(broadcaster_id: "141981764", has_delay: false)
    end
  end
end