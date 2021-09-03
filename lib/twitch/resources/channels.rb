module Twitch
  class ChannelsResource < Resource
    
    def get(broadcaster_id:)
      User.new get_request("channels?broadcaster_id=#{broadcaster_id}").body.dig("data")[0]
    end

    # Requires scope: channel:manage:broadcast
    def update(broadcaster_id:, **attributes)
      patch_request("channels?broadcaster_id=#{broadcaster_id}", body: attributes)
    end

    # Requires scope: channel:read:editors
    def editors(broadcaster_id:)
      response = get_request("channels/editors/?broadcaster_id=#{broadcaster_id}")
      Collection.from_response(response, key: "data", type: ChannelEditor)
    end

  end
end
