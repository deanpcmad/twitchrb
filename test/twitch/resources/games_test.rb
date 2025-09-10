require "test_helper"

class GamesResourceTest < Minitest::Test
  def test_games_retrieve_by_id
    setup_client
    game = @client.games.retrieve(id: "33214")

    assert_equal Twitch::Game, game.class
    assert_equal "Fortnite", game.name
  end

  def test_games_retrieve_by_ids
    setup_client
    games = @client.games.retrieve(ids: ["33214", "509658"])

    assert_equal Twitch::Collection, games.class
    assert_equal 2, games.data.count
    assert games.data.all? { |game| game.is_a?(Twitch::Game) }
  end

  def test_games_retrieve_by_name
    setup_client
    game = @client.games.retrieve(name: "Fortnite")

    assert_equal Twitch::Game, game.class
    assert_equal "33214", game.id
  end

  def test_games_retrieve_by_names
    setup_client
    games = @client.games.retrieve(names: ["Fortnite", "Just Chatting"])

    assert_equal Twitch::Collection, games.class
    assert_equal 2, games.data.count
    assert games.data.all? { |game| game.is_a?(Twitch::Game) }
  end

  def test_games_retrieve_missing_params_raises_error
    setup_client
    
    assert_raises(RuntimeError) do
      @client.games.retrieve
    end
  end

  def test_games_top
    setup_client
    games = @client.games.top(first: 10)

    assert_equal Twitch::Collection, games.class
    assert games.data.count <= 10
    assert games.data.all? { |game| game.is_a?(Twitch::Game) }
  end

  def test_games_top_with_pagination
    setup_client
    
    # First get real pagination cursor from a top games call
    first_page = @client.games.top(first: 5)
    
    if first_page.cursor
      games = @client.games.top(first: 5, after: first_page.cursor)
      
      assert_equal Twitch::Collection, games.class
      assert games.data.count <= 5
      assert games.data.all? { |game| game.is_a?(Twitch::Game) }
    else
      # Test just verifies basic functionality without pagination
      assert_equal Twitch::Collection, first_page.class
      assert first_page.data.count <= 5
      assert first_page.data.all? { |game| game.is_a?(Twitch::Game) }
    end
  end
end