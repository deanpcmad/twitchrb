module Twitch
  class Games

    class << self

      # Gets Badges for a channel ID
      def get_by_name(name)
        response = Twitch.client.get(:helix, "games?name=#{name}")

        Twitch::Models::Game.new(response["data"][0])
      end

      def get_by_id(id)
        response = Twitch.client.get(:helix, "games?id=#{id}")

        Twitch::Models::Game.new(response["data"][0])
      end

      # Gets Top Games
      def get_top
        response = Twitch.client.get(:helix, "games/top")

        game_array(response["data"])
      end

      private

      def game_array(data)
        games = []

        data.each do |g|
          games << Twitch::Models::Game.new(g)
        end

        games
      end

    end

  end
end
