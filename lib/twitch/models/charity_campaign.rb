module Twitch
  class CharityCampaign < Object

    class << self

      # Required scope: channel:read:charity
      # Broadcaster ID must match the user in the OAuth token
      def list(broadcaster_id:)
        response = Client.get_request("charity/campaigns?broadcaster_id=#{broadcaster_id}")
        if response.body.dig("data")[0]
          CharityCampaign.new(response.body.dig("data")[0])
        else
          nil
        end
      end

    end

  end
end
