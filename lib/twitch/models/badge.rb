module Twitch
  class Badge < Object

    class << self

      def channel(broadcaster_id:)
        response = Client.get_request("chat/badges?broadcaster_id=#{broadcaster_id}")
        Collection.from_response(response, type: Badge)
      end

      def global
        response = Client.get_request("chat/badges/global")
        Collection.from_response(response, type: Badge)
      end

    end

  end
end
