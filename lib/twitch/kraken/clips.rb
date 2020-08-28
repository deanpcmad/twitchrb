module Twitch
  module Kraken
    class Clips

      include Initializable

      attr_accessor :id, :title, :slug, :url, :embed_url, :game, :views, :duration, :language, :broadcaster, :curator, :vod, :created_at, :updated_at

      class << self

        # Gets details about a specified clip
        def get(slug)
          response = Twitch.client.get(:kraken, "clips/#{slug}")

          new(response)
        end

      end

    end
  end
end
