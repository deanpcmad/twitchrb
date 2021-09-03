module Twitch
  class VideosResource < Resource
    
    def list(**params)
      raise "id, user_id or game_id is required" unless !params[:id].nil? || !params[:user_id].nil? || !params[:game_id].nil?

      response = get_request("videos", params: params)
      Collection.from_response(response, key: "data", type: Video)
    end

    # Required scope: channel:manage:videos
    # def delete(video_id:)
    #   delete_request("videos?id=#{video_id}")
    # end

  end
end
