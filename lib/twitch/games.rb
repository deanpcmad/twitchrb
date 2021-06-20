module Twitch
  class Games

    include Initializable

    attr_accessor :id, :name, :box_art_url

    def box_art_380
      box_art_url.gsub("{width}", "285").gsub("{height}", "380")
    end

    class << self

      # Gets Badges for a channel ID
      def get_by_name(name)
        response = Twitch.client.get(:helix, "games?name=#{name}")

        new(response["data"][0])
      end

      def get_by_id(id)
        response = Twitch.client.get(:helix, "games?id=#{id}")

        new(response["data"][0])
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
          games << new(g)
        end

        games
      end

    end

  end
end
