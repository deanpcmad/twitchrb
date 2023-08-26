module Twitch
  class Announcement < Object

    class << self

      # Moderator ID must match the user in the OAuth token
      # Required scope: moderator:manage:announcements
      def create(broadcaster_id:, moderator_id:, message:, color: nil)
        attrs = {message: message, color: color}

        Client.post_request("chat/announcements?broadcaster_id=#{broadcaster_id}&moderator_id=#{moderator_id}", body: attrs)
      end

    end

  end
end
