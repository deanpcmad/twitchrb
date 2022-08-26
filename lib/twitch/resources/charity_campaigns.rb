module Twitch
  class CharityCampaignsResource < Resource
    
    # Required scope: channel:read:charity
    # Broadcaster ID must match the user in the OAuth token
    def list(broadcaster_id:)
      response = get_request("charity/campaigns?broadcaster_id=#{broadcaster_id}")
      Collection.from_response(response, type: CharityCampaign)
    end

  end
end
