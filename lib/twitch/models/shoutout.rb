module Twitch
  class Shoutout < Object

    class << self

      # Moderator ID must match the user in the OAuth token
      # From: the ID of the Broadcaster creating the Shoutout
      # To: the ID of the Broadcaster the Shoutout will be for
      # Required scope: moderator:manage:shoutouts
      def create(from:, to:, moderator_id:)
        Client.post_request("chat/shoutouts?from_broadcaster_id=#{from}&to_broadcaster_id=#{to}&moderator_id=#{moderator_id}", body: nil)
      end

    end

  end
end
