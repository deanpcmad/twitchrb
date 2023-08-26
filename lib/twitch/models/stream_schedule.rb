module Twitch
  class StreamSchedule < Object

    class << self

      # Broadcaster ID must match the user in the OAuth token
      def list(broadcaster_id:, **params)
        response = Client.get_request("schedule", params: params.merge(broadcaster_id: broadcaster_id))

        StreamSchedule.new(response.body) if response.success?
      end

      # Broadcaster ID must match the user in the OAuth token
      def icalendar(broadcaster_id:)
        response = Client.get_request("schedule/icalendar", params: {broadcaster_id: broadcaster_id})

        response.body
      end

      # Broadcaster ID must match the user in the OAuth token
      # TODO: Allow the user to put any date format and then convert it to RFC3339
      def update(broadcaster_id:, **params)
        Client.patch_request("schedule/settings", body: params.merge(broadcaster_id: broadcaster_id))
      end

      # Broadcaster ID must match the user in the OAuth token
      def create_segment(broadcaster_id:, start_time:, timezone:, duration:, is_recurring:, **params)
        attrs = {broadcaster_id: broadcaster_id, start_time: start_time, duration: duration, timezone: timezone, is_recurring: is_recurring}
        response = Client.post_request("schedule/segment", body: attrs.merge(params))

        StreamSchedule.new(response.body) if response.success?
      end

      # Broadcaster ID must match the user in the OAuth token
      def update_segment(broadcaster_id:, id:, **params)
        attrs = {broadcaster_id: broadcaster_id, id: id}
        response = Client.patch_request("schedule/segment", body: attrs.merge(params))

        StreamSchedule.new(response.body) if response.success?
      end

      # Broadcaster ID must match the user in the OAuth token
      def delete_segment(broadcaster_id:, id:)
        attrs = {broadcaster_id: broadcaster_id, id: id}
        Client.delete_request("schedule/segment", params: attrs)
      end

    end

  end
end
