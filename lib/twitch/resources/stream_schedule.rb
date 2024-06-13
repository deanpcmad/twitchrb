module Twitch
  class StreamScheduleResource < Resource
    # Broadcaster ID must match the user in the OAuth token
    def list(broadcaster_id:, **params)
      response = get_request("schedule", params: params.merge(broadcaster_id: broadcaster_id))

      StreamSchedule.new(response.body) if response.success?
    end

    # Broadcaster ID must match the user in the OAuth token
    def icalendar(broadcaster_id:)
      response = get_request("schedule/icalendar", params: { broadcaster_id: broadcaster_id })

      response.body
    end

    # Broadcaster ID must match the user in the OAuth token
    # TODO: Allow the user to put any date format and then convert it to RFC3339
    def update(broadcaster_id:, **params)
      patch_request("schedule/settings", body: params.merge(broadcaster_id: broadcaster_id))
    end

    # Broadcaster ID must match the user in the OAuth token
    def create_segment(broadcaster_id:, start_time:, timezone:, duration:, is_recurring:, **params)
      attrs = { broadcaster_id: broadcaster_id, start_time: start_time, duration: duration, timezone: timezone, is_recurring: is_recurring }
      response = post_request("schedule/segment", body: attrs.merge(params))

      StreamSchedule.new(response.body) if response.success?
    end

    # Broadcaster ID must match the user in the OAuth token
    def update_segment(broadcaster_id:, id:, **params)
      attrs = { broadcaster_id: broadcaster_id, id: id }
      response = patch_request("schedule/segment", body: attrs.merge(params))

      StreamSchedule.new(response.body) if response.success?
    end

    # Broadcaster ID must match the user in the OAuth token
    def delete_segment(broadcaster_id:, id:)
      attrs = { broadcaster_id: broadcaster_id, id: id }
      delete_request("schedule/segment", params: attrs)
    end
  end
end
