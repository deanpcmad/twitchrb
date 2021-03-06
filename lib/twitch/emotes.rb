module Twitch
  class Emotes

    class << self

      # Gets Emotes for a channel ID
      def get_channel(id)
        response = Twitch.client.get(:helix, "chat/emotes?broadcaster_id=#{id}")

        emote_array(response["data"])
      end

      # Gets Global Emotes
      def get_global
        response = Twitch.client.get(:helix, "chat/emotes/global")

        emote_array(response["data"])
      end

      # Gets Emotes for an Emote Set ID
      def get_emote_set(id)
        response = Twitch.client.get(:helix, "chat/emotes/set?emote_set_id=#{id}")

        emote_array(response["data"])
      end

      private

      def emote_array(data)
        emotes = []

        data.each do |e|
          emotes << Twitch::Models::Emote.new(e)
        end

        emotes
      end

    end

  end
end
