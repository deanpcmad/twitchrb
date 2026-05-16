module Twitch
  class EventsubSubscriptionsResource < Resource
    def list(**params)
      response = get_request("eventsub/subscriptions", params: params)
      Collection.from_response(response, type: EventsubSubscription)
    end

    def create(type:, version:, condition:, transport:, **params)
      attributes = { type: type, version: version, condition: condition, transport: transport }.merge(params)
      response = client.connection.post("eventsub/subscriptions", attributes)
      update_rate_limit(response)

      if response.status == 409
        raise Twitch::Errors::EventsubSubscriptionConflictError.new(
          response.body,
          response.status,
          existing_subscription_id: response.body.dig("data", 0, "id")
        )
      end

      return raise_error(response) if error?(response)

      EventsubSubscription.new(response.body.dig("data")[0]) if response.success?
    end

    def delete(id:)
      delete_request("eventsub/subscriptions", params: { id: id })
    end
  end
end
