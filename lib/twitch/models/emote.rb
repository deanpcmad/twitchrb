module Twitch
  module Models
    class Emote

      include Initializable

      attr_accessor :id, :name, :images, :tier, :emote_type, :emote_set_id, :owner_id

      def url_1x
        images["url_1x"]
      end

      def url_2x
        images["url_2x"]
      end

      def url_4x
        images["url_4x"]
      end

    end
  end
end
