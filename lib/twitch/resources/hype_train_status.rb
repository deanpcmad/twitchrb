module Twitch
  class HypeTrainStatusResource < Resource
    # Required scope: channel:read:hype_train
    # Broadcaster ID must match the user in the OAuth token
    def retrieve(broadcaster_id:)
      response = get_request("hypetrain/status", params: { broadcaster_id: broadcaster_id })
      data = response.body.dig("data")

      return nil if data.nil? || data.empty?

      HypeTrainStatus.new(data[0])
    end
  end
end
