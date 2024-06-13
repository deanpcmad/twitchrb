module Twitch
  class WhispersResource < Resource
    def create(from_user_id:, to_user_id:, message:)
      post_request("whispers", body: { from_user_id: from_user_id, to_user_id: to_user_id, message: message })
    end
  end
end
