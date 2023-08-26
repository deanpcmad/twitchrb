module Twitch
  class Whisper < Object

    class << self

      def create(from_user_id:, to_user_id:, message:)
        Client.post_request("whispers", body: {from_user_id: from_user_id, to_user_id: to_user_id, message: message})
      end

    end

  end
end
