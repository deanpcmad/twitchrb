module Twitch
  class Goal < Object

    class << self

      # Required scope: channel:read:goals
      # Broadcaster ID must match the user in the OAuth token
      def list(broadcaster_id:)
        response = Client.get_request("goals", params: {broadcaster_id: broadcaster_id})
        Collection.from_response(response, type: Goal)
      end

    end

  end
end
