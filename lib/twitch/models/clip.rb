module Twitch
  class Clip < Object

    class << self

      def list(**params)
        raise "id, broadcaster_id or game_id is required" unless !params[:id].nil? || !params[:broadcaster_id].nil? || !params[:game_id].nil?

        response = Client.get_request("clips", params: params)
        Collection.from_response(response, type: Clip)
      end

      def retrieve(id:)
        Clip.new Client.get_request("clips?id=#{id}").body.dig("data")[0]
      end

      # Required scope: clips:edit
      def create(broadcaster_id:, **attributes)
        response = Client.post_request("clips", body: attributes.merge(broadcaster_id: broadcaster_id))

        Clip.new(response.body.dig("data")[0]) if response.success?
      end

    end

  end
end
