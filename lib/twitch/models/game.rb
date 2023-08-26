module Twitch
  class Game < Object

    class << self

      def retrieve(id: nil, ids: nil, name: nil, names: nil)
        raise "Either id, ids, name or names is required" unless !id.nil? || !ids.nil? || !name.nil? || !names.nil?

        if id
          response = Client.get_request("games", params: {id: id})
        elsif ids
          response = Client.get_request("games", params: {id: ids})
        elsif names
          response = Client.get_request("games", params: {name: names})
        else
          response = Client.get_request("games", params: {name: name})
        end

        body = response.body.dig("data")
        if body.count == 1
          Game.new body[0]
        elsif body.count > 1
          Collection.from_response(response, type: Game)
        else
          return nil
        end
      end

      def top(**params)
        response = Client.get_request("games/top", params: params)
        Collection.from_response(response, type: Game)
      end

    end

  end
end
