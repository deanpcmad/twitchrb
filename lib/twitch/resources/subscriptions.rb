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

    # Calculate the number of Subscribers & Subscriber Points a broadcaster has
    # Broadcaster ID must match the user in the OAuth token
    # Required scope: channel:read:subscriptions
    def calculate(broadcaster_id:, remove_count: 0, remove_points: 0)
      calculate_subs(broadcaster_id: broadcaster_id, remove_count: remove_count, remove_points: remove_points)
    end
    
    private

    def get_subscriptions(broadcaster_id:)
      subs    = []
      cursor  = nil
      count   = 1
  
      while count > 0
        sub_response = list(broadcaster_id: broadcaster_id, first: 100, after: cursor)
  
        subs    += sub_response.data
  
        cursor  = sub_response.cursor
        count   = sub_response.total
      end
  
      return subs
    end
  
    def calculate_subs(broadcaster_id:, remove_count:, remove_points:)
      subs = get_subscriptions(broadcaster_id: broadcaster_id)
  
      count  = 0
      points = 0
  
      if !subs.empty? && subs.count >= 1
        subs.each do |sub|
          # We don't want to add the broadcaster into the count
          next if sub.user_id.to_s == broadcaster_id.to_s
          
          count  += 1
          points += 1 if sub.tier == "1000"
          points += 2 if sub.tier == "2000"
          points += 6 if sub.tier == "3000"
        end

        count  = (count - remove_count)
        points = (points - remove_points)
      end
  
      SubscriptionCount.new(count: count, points: points)
    end 

  end
end
