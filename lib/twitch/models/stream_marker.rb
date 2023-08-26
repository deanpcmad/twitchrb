module Twitch
  class StreamMarker < Object

    class << self

      # Required scope: user:read:broadcast
      def list(**params)
        response = Client.get_request("streams/markers", params: params)

        Collection.from_response(response, type: StreamMarker)
      end

      # Required scope: channel:manage:broadcast
      def create(user_id:, **params)
        response = Client.post_request("streams/markers", body: params.merge(user_id: user_id))

        StreamMarker.new(response.body.dig("data")[0]) if response.success?
      end

    end

  end
end
