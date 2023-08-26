module Twitch
  class Video < Object

    class << self

      def list(**params)
        raise "id, user_id or game_id is required" unless !params[:id].nil? || !params[:user_id].nil? || !params[:game_id].nil?

        response = Client.get_request("videos", params: params)
        Collection.from_response(response, type: Video)
      end

      # Required scope: channel:manage:videos
      def delete(id:)
        Client.delete_request("videos?id=#{id}")
      end

    end

  end
end
