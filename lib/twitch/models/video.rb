module Twitch
  class Video < Object

    class << self

      def list(**params)
        raise "user_id or game_id is required" unless !params[:user_id].nil? || !params[:game_id].nil?

        response = Client.get_request("videos", params: params)
        Collection.from_response(response, type: Video)
      end

      def retrieve(id:)
        response = Client.get_request("videos", params: {id: id})
        if response.body
          Game.new response.body["data"].first
        end
      end

      # Required scope: channel:manage:videos
      def delete(id:)
        Client.delete_request("videos?id=#{id}")
      end

    end

  end
end
