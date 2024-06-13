module Twitch
  class HypeTrainEventsResource < Resource
    # Required scope: channel:read:hype_train
    # Broadcaster ID must match the user in the OAuth token
    def list(broadcaster_id:)
      response = get_request("hypetrain/events", params: { broadcaster_id: broadcaster_id })
      Collection.from_response(response, type: HypeTrainEvent)
    end
  end
end
