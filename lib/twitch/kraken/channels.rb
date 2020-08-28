module Twitch
  module Kraken
    class Channels

      include Initializable

      attr_accessor :id, :name, :display_name, :broadcaster_language, :followers, :game, :language, :logo, :mature, :partner, :profile_banner, :profile_banner_background_colour, :status, :url, :video_banner, :views, :created_at, :updated_at

      class << self

        # Gets a specified channel object
        def get_channel_by_id(id)
          response = Twitch.client.get(:kraken, "channels/#{id}")

          new(response)
        end

      end

    end
  end
end
