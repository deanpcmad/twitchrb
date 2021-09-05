module Twitch
  class ModeratorsResource < Resource
    
    # Broadcaster ID must match the user in the OAuth token
    def list(broadcaster_id:, **params)
      response = get_request("moderation/moderators", params: params.merge(broadcaster_id: broadcaster_id))
      Collection.from_response(response, type: Moderator)
    end

  end
end
