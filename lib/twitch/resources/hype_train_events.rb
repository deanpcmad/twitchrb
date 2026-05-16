module Twitch
  class HypeTrainEventsResource < Resource
    # Required scope: channel:read:hype_train
    # Broadcaster ID must match the user in the OAuth token
    def list(broadcaster_id:)
      warn "`hype_train_events.list` is deprecated because Twitch removed GET /helix/hypetrain/events. Use `hype_train_status.retrieve` instead."
      HypeTrainStatusResource.new(client).retrieve(broadcaster_id: broadcaster_id)
    end
  end
end
