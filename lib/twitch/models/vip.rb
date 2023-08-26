module Twitch
  class Vip < Object

    class << self

      # Broadcaster ID must match the user in the OAuth token
      def list(broadcaster_id:, **params)
        response = Client.get_request("channels/vips", params: params.merge(broadcaster_id: broadcaster_id))
        Collection.from_response(response, type: Vip)
      end

      def create(broadcaster_id:, user_id:)
        Client.post_request("channels/vips", body: {broadcaster_id: broadcaster_id, user_id: user_id})
      end

      def delete(broadcaster_id:, user_id:)
        Client.delete_request("channels/vips?broadcaster_id=#{broadcaster_id}&user_id=#{user_id}")
      end

    end

  end
end
