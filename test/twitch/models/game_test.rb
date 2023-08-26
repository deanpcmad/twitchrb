require "test_helper"

class GameTest < Minitest::Test

  def test_game_retrieve_with_id
    game = Twitch::Game.retrieve(id: 514974)

    assert_equal Twitch::Game, game.class
    assert_equal "Battlefield 2042", game.name
    assert_equal "514974", game.id
  end

  def test_game_retrieve_with_ids
    games = Twitch::Game.retrieve(ids: [66402, 514974])

    assert_equal Twitch::Collection, games.class
    assert_equal Twitch::Game, games.data.first.class
    assert_equal "Battlefield 4", games.data.first.name
    assert_equal "Battlefield 2042", games.data.last.name
  end

  def test_game_retrieve_with_name
    game = Twitch::Game.retrieve(name: "Battlefield 4")

    assert_equal Twitch::Game, game.class
    assert_equal "Battlefield 4", game.name
    assert_equal "66402", game.id
  end

  def test_game_retrieve_with_names
    games = Twitch::Game.retrieve(names: ["Battlefield 4", "Battlefield 2042"])

    assert_equal Twitch::Collection, games.class
    assert_equal Twitch::Game, games.data.first.class
    assert_equal "66402", games.data.first.id
  end

  def test_game_top
    games = Twitch::Game.top

    assert_equal Twitch::Collection, games.class
    assert_equal Twitch::Game, games.data.first.class
  end

end
