module Twitch
  class BannedEventsResource < Resource
    def list(broadcaster_id:, **params)
      response = get_request("moderation/banned/events", params: params.merge(broadcaster_id: broadcaster_id))
      Collection.from_response(response, type: BannedEvent)
    end
  end
end
