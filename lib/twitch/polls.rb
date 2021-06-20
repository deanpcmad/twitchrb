module Twitch
  class Polls

    class << self

      # Gets Polls for a channel ID
      def get_channel(id)
        response = Twitch.client.get(:helix, "polls?broadcaster_id=#{id}")

        if response["data"].count > 1
          polls = []
          response["data"].each do |p|
            polls << Twitch::Models::Poll.new(p)
          end
          polls
        else
          Twitch::Models::Poll.new(response["data"][0])
        end
      end

      # Create a Poll
      def create(broadcaster_id, params={})
        params[:broadcaster_id] = broadcaster_id
        response = Twitch.client.post(:helix, "polls", params)

        Twitch::Models::Poll.new(response["data"][0])
      end

      # End a Poll
      # Status should be TERMINATED or ARCHIVED
      def end(broadcaster_id, id, status)
        params = {}
        params[:broadcaster_id] = broadcaster_id
        params[:id] = id
        params[:status] = status

        response = Twitch.client.patch(:helix, "polls", params)

        Twitch::Models::Poll.new(response["data"][0])
      end

    end

  end
end
