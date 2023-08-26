module Twitch
  class ChatMessage < Object

    class << self

      # moderator_id must match the user in the OAuth token
      def delete(broadcaster_id:, moderator_id:, message_id:)
        Client.delete_request("moderation/chat?broadcaster_id=#{broadcaster_id}&moderator_id=#{moderator_id}&message_id=#{message_id}")
      end

    end

  end
end
