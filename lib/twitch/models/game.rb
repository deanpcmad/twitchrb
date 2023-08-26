module Twitch
  class Game < Object

    class << self

      def get_by_id(game_id:)
        response = Client.get_request("games?id=#{game_id}")
        Collection.from_response(response, type: Game)
      end

      def get_by_name(name:)
        response = Client.get_request("games?name=#{name}")
        Collection.from_response(response, type: Game)
      end

      def top(**params)
        response = Client.get_request("games/top", params: params)
        Collection.from_response(response, type: Game)
      end

    end

  end
end
