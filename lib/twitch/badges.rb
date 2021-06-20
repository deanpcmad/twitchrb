module Twitch
  class Badges

    include Initializable

    attr_accessor :id, :image_url_1x, :image_url_2x, :image_url_4x

    class << self

      # Gets Badges for a channel ID
      def get_channel(id)
        response = Twitch.client.get(:helix, "chat/badges?broadcaster_id=#{id}")

        badge_array(response["data"])
      end

      # Gets Global Badges
      def get_global
        response = Twitch.client.get(:helix, "chat/badges/global")

        badge_array(response["data"])
      end

      private

      def badge_array(data)
        badges = []

        data.each do |e|
          badges << {set_id: e["set_id"], versions: e["versions"].map {|v| new(v)} }
        end

        badges
      end

    end

  end
end
