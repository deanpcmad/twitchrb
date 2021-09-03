module Twitch
  class GamesResource < Resource

    def get_by_id(game_id:)
      response = get_request("games?id=#{game_id}")
      Collection.from_response(response, key: "data", type: Game)
    end

    def get_by_name(name:)
      response = get_request("games?name=#{name}")
      Collection.from_response(response, key: "data", type: Game)
    end

    def top(**params)
      response = get_request("games/top", params: params)
      Collection.from_response(response, key: "data", type: Game)
    end

  end
end
