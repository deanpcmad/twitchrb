module Twitch
  class HypeTrainEvent < Object

    class << self

      # Required scope: channel:read:hype_train
      # Broadcaster ID must match the user in the OAuth token
      def list(broadcaster_id:)
        response = Client.get_request("hypetrain/events", params: {broadcaster_id: broadcaster_id})
        Collection.from_response(response, type: HypeTrainEvent)
      end

    end

  end
end
