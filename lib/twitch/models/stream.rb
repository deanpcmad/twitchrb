module Twitch
  class Stream < Object

    class << self

      def list(**params)
        response = Client.get_request("streams", params: params)

        Collection.from_response(response, type: Stream)
      end

      # Required scope: user:read:follows
      # User ID must match the user in the OAuth token
      def followed(user_id:, **params)
        response = Client.get_request("streams/followed", params: params.merge(user_id: user_id))

        Collection.from_response(response, type: Stream)
      end

    end

  end
end
