module Twitch
  class SubscriptionsResource < Resource

    # Get all subscriptions for a broadcaster
    # Broadcaster ID must match the user in the OAuth token
    # Required scope: channel:read:subscriptions
    def list(broadcaster_id:, **params)
      response = get_request("subscriptions", params: params.merge(broadcaster_id: broadcaster_id))
      Collection.from_response(response, key: "data", type: Subscription)
    end
    
    # Checks if a User is subscribed to a Broadcaster
    # If 404 then the user is not subscribed
    # User ID must match the user in the OAuth token
    # Required scope: user:read:subscriptions
    def is_subscribed(broadcaster_id:, user_id:, **params)
      attrs = {broadcaster_id: broadcaster_id, user_id: user_id}
      response = get_request("subscriptions/user", params: attrs.merge(params))
      Collection.from_response(response, key: "data", type: Subscription)
    end

  end
end
