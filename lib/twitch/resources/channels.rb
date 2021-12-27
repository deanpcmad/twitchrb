module Twitch
  class ChannelsResource < Resource
    
    def get(broadcaster_id:)
      Channel.new get_request("channels?broadcaster_id=#{broadcaster_id}").body.dig("data")[0]
    end

    # Requires scope: channel:manage:broadcast
    def update(broadcaster_id:, **attributes)
      patch_request("channels", body: attributes.merge(broadcaster_id: broadcaster_id))
    end

    # Requires scope: channel:read:editors
    def editors(broadcaster_id:)
      response = get_request("channels/editors?broadcaster_id=#{broadcaster_id}")
      Collection.from_response(response, type: ChannelEditor)
    end

  end
end
