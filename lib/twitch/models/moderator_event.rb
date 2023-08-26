module Twitch
  class ModeratorEvent < Object

    class << self

      # Broadcaster ID must match the user in the OAuth token
      def list(broadcaster_id:, **params)
        response = Client.get_request("moderation/moderators/events", params: params.merge(broadcaster_id: broadcaster_id))
        Collection.from_response(response, type: ModeratorEvent)
      end

    end

  end
end
