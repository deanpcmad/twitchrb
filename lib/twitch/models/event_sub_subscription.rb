module Twitch
  class EventSubSubscription < Object

    class << self

      def list(**params)
        response = Client.get_request("eventsub/subscriptions", params: params)
        Collection.from_response(response, type: EventSubSubscription)
      end

      def create(type:, version:, condition:, transport:)
        attributes = {type: type, version: version, condition: condition, transport: transport}
        response = Client.post_request("eventsub/subscriptions", body: attributes)

        EventSubSubscription.new(response.body.dig("data")[0]) if response.success?
      end

      def delete(id:)
        Client.delete_request("eventsub/subscriptions", params: {id: id})
      end

    end

  end
end
