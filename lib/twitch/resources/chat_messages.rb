module Twitch
  class ChatMessagesResource < Resource
    def create(broadcaster_id:, sender_id:, message:, reply_to: nil)
      attrs = { broadcaster_id: broadcaster_id, sender_id: sender_id, message: message, reply_parent_message_id: reply_to }

      response = post_request("chat/messages", body: attrs)
      ChatMessage.new(response.body.dig("data")[0])
    end

    # moderator_id must match the user in the OAuth token
    def delete(broadcaster_id:, moderator_id:, message_id:)
      delete_request("moderation/chat?broadcaster_id=#{broadcaster_id}&moderator_id=#{moderator_id}&message_id=#{message_id}")
    end
  end
end
