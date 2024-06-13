module Twitch
  class EventSubSubscriptionsResource < Resource
    def list(**params)
      response = get_request("eventsub/subscriptions", params: params)
      Collection.from_response(response, type: EventSubSubscription)
    end

    def create(type:, version:, condition:, transport:, **params)
      attributes = { type: type, version: version, condition: condition, transport: transport }.merge(params)
      response = post_request("eventsub/subscriptions", body: attributes)

      EventSubSubscription.new(response.body.dig("data")[0]) if response.success?
    end

    def delete(id:)
      delete_request("eventsub/subscriptions", params: { id: id })
    end
  end
end
