module Twitch
  class CustomRewardsResource < Resource
    # Required scope: channel:read:redemptions
    # Broadcaster ID must match the user in the OAuth token
    def list(broadcaster_id:, **params)
      response = get_request("channel_points/custom_rewards", params: params.merge(broadcaster_id: broadcaster_id))
      Collection.from_response(response, type: CustomReward)
    end

    def create(broadcaster_id:, title:, cost:, **params)
      attributes = { broadcaster_id: broadcaster_id, title: title, cost: cost }
      response = post_request("channel_points/custom_rewards", body: attributes.merge(params))

      CustomReward.new(response.body.dig("data")[0]) if response.success?
    end

    def update(broadcaster_id:, reward_id:, **params)
      attributes = { broadcaster_id: broadcaster_id, id: reward_id }
      response = patch_request("channel_points/custom_rewards", body: attributes.merge(params))

      CustomReward.new(response.body.dig("data")[0]) if response.success?
    end

    def delete(broadcaster_id:, reward_id:)
      delete_request("channel_points/custom_rewards", params: { broadcaster_id: broadcaster_id, id: reward_id })
    end
  end
end
