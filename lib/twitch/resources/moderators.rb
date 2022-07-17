module Twitch
  class ModeratorsResource < Resource
    
    # Broadcaster ID must match the user in the OAuth token
    def list(broadcaster_id:, **params)
      response = get_request("moderation/moderators", params: params.merge(broadcaster_id: broadcaster_id))
      Collection.from_response(response, type: Moderator)
    end

    def create(broadcaster_id:, user_id:)
      post_request("moderation/moderators", body: {broadcaster_id: broadcaster_id, user_id: user_id})
    end

    def delete(broadcaster_id:, user_id:)
      delete_request("moderation/moderators?broadcaster_id=#{broadcaster_id}&user_id=#{user_id}")
    end

  end
end
