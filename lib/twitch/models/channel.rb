module Twitch
  class Channel < Object

    class << self

      def retrieve(id:)
        response = Client.get_request("channels", params: {broadcaster_id: id})
        Channel.new response.body.dig("data")[0]
      end

      # Retrieve a list of broadcasters a specified user follows
      # Required scope: user:read:follows
      # id must match the authenticated user
      def followed(id:, **params)
        response = Client.get_request("channels/followed", params: params.merge(user_id: id))
        Collection.from_response(response, type: User)
      end

      # Retrieve a list of users that follow a specified broadcaster
      # Required scope: moderator:read:followers
      # id must match the authenticated user
      def followers(id:, **params)
        response = Client.get_request("channels/followers", params: params.merge(broadcaster_id: id))
        Collection.from_response(response, type: User)
      end

      # Grabs the number of Followers a broadcaster has
      def follows_count(id:)
        response = Client.get_request("channels/followers", params: {broadcaster_id: id})

        FollowCount.new(count: response.body["total"])
      end

      # Grabs the number of Subscribers and Subscriber Points a broadcaster has
      # Required scope: channel:read:subscriptions
      def subscribers_count(id:)
        response = Client.get_request("subscriptions", params: {broadcaster_id: id})

        SubscriptionCount.new(count: response.body["total"], points: response.body["points"])
      end

      # Requires scope: channel:manage:broadcast
      def update(id:, **attributes)
        Client.patch_request("channels", body: attributes.merge(broadcaster_id: id))
      end

      # Requires scope: channel:read:editors
      def editors(id:)
        response = Client.get_request("channels/editors", params: {broadcaster_id: id})
        Collection.from_response(response, type: ChannelEditor)
      end

    end

  end
end
