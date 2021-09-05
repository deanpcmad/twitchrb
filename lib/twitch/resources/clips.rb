module Twitch
  class ClipsResource < Resource
    
    def list(**params)
      raise "id, broadcaster_id or game_id is required" unless !params[:id].nil? || !params[:broadcaster_id].nil? || !params[:game_id].nil?

      response = get_request("clips", params: params)
      Collection.from_response(response, type: Clip)
    end

    # Required scope: clips:edit
    def create(broadcaster_id:, **attributes)
      response = post_request("clips", body: attributes.merge(broadcaster_id: broadcaster_id))
      
      Clip.new(response.body.dig("data")[0]) if response.success?
    end

  end
end
