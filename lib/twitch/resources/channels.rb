module Twitch
  class ChannelsResource < Resource
    
    def get(broadcaster_id:)
      Channel.new get_request("channels?broadcaster_id=#{broadcaster_id}").body.dig("data")[0]
    end

    # Grabs the number of Followers a broadcaster has
    def follows_count(broadcaster_id:)
      response = get_request("users/follows", params: {to_id: broadcaster_id})

      FollowCount.new(count: response.body["total"])
    end

    # Grabs the number of Subscribers and Subscriber Points a broadcaster has
    # Required scope: channel:read:subscriptions
    def subscribers_count(broadcaster_id:)
      response = get_request("subscriptions", params: {broadcaster_id: broadcaster_id})

      SubscriptionCount.new(count: response.body["total"], points: response.body["points"])
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
