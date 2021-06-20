module Twitch
  module Models
    class Game

      include Initializable

      attr_accessor :id, :name, :box_art_url

      def box_art_380
        box_art_url.gsub("{width}", "285").gsub("{height}", "380")
      end

    end
  end
end
