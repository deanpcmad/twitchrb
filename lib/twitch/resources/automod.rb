module Twitch
  class AutomodResource < Resource

    # Checks if a supplied message meets the channel's AutoMod requirements
    # Required scope: moderation:read
    def check_status(broadcaster_id:, id:, text:)
      attrs = {broadcaster_id: broadcaster_id, data: [{msg_id: id, msg_text: text}]}
      response = post_request("moderation/enforcements/status", body: attrs)
      AutomodStatus.new response.body.dig("data")[0]
    end

    # Checks if multiple supplied messages meet the channel's AutoMod requirements
    # Required scope: moderation:read
    def check_status_multiple(broadcaster_id:, messages:)
      attrs = {broadcaster_id: broadcaster_id, data: messages}
      response = post_request("moderation/enforcements/status", body: attrs)
      Collection.from_response(response, type: AutomodStatus)
    end
    
  end
end
