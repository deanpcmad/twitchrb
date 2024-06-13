module Twitch
  class ClipsResource < Resource
    def list(**params)
      raise "broadcaster_id or game_id is required" unless !params[:broadcaster_id].nil? || !params[:game_id].nil?

      response = get_request("clips", params: params)
      Collection.from_response(response, type: Clip)
    end

    def retrieve(id:)
      Clip.new get_request("clips", params: { id: id }).body.dig("data")[0]
    end

    # Required scope: clips:edit
    def create(broadcaster_id:, **attributes)
      response = post_request("clips", body: attributes.merge(broadcaster_id: broadcaster_id))

      Clip.new(response.body.dig("data")[0]) if response.success?
    end
  end
end
