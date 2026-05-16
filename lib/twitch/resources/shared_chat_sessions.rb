module Twitch
  class SharedChatSessionsResource < Resource
    def retrieve(broadcaster_id:)
      response = get_request("shared_chat/session", params: { broadcaster_id: broadcaster_id })
      data = response.body.dig("data")

      return nil if data.nil? || data.empty?

      SharedChatSession.new(data[0])
    end
  end
end
