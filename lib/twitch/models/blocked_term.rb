module Twitch
  class BlockedTerms < Object

    class << self

      # Required scope: moderator:read:blocked_terms
      # moderator_id must match the currently authenticated user. Can be either the broadcaster ID or moderator ID
      def list(broadcaster_id:, moderator_id:, **params)
        attrs = {broadcaster_id: broadcaster_id, moderator_id: moderator_id}
        response = Client.get_request("moderation/blocked_terms", params: attrs.merge(params))
        Collection.from_response(response, type: BlockedTerm)
      end

      # Required scope: moderator:manage:blocked_terms
      # moderator_id must match the currently authenticated user. Can be either the broadcaster ID or moderator ID
      def create(broadcaster_id:, moderator_id:, text:)
        attrs = {broadcaster_id: broadcaster_id, moderator_id: moderator_id, text: text}
        response = Client.post_request("moderation/blocked_terms", body: attrs)
        BannedUser.new response.body.dig("data")[0]
      end

      # Required scope: moderator:manage:blocked_terms
      # moderator_id must match the currently authenticated user. Can be either the broadcaster ID or moderator ID
      def delete(broadcaster_id:, moderator_id:, id:)
        Client.delete_request("moderation/blocked_terms?broadcaster_id=#{broadcaster_id}&moderator_id=#{moderator_id}&id=#{id}")
      end

    end

  end
end
