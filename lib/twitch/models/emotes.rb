module Twitch
  class Emote < Object

    class << self

      def channel(broadcaster_id:)
        response = Client.get_request("chat/emotes?broadcaster_id=#{broadcaster_id}")
        Collection.from_response(response, type: Emote)
      end

      def global
        response = Client.get_request("chat/emotes/global")
        Collection.from_response(response, type: Emote)
      end

      def sets(emote_set_id:)
        response = Client.get_request("chat/emotes/set?emote_set_id=#{emote_set_id}")
        Collection.from_response(response, type: Emote)
      end

    end

  end
end
