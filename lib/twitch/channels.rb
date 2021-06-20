module Twitch
  class Channels

    class << self

      # Gets a specified channel object
      def get(id)
        response = Twitch.client.get(:helix, "channels?broadcaster_id=#{id}")

        Twitch::Models::Channel.new(response["data"][0])
      end

      # Update a channel
      def update(id, params={})
        Twitch.client.patch(:helix, "channels?broadcaster_id=#{id}", params)
      end

    end

  end
end
