module Twitch
  module Models
    class PollChoice

      include Initializable

      attr_accessor :id, :title, :votes, :channel_points_votes, :bits_votes

    end
  end
end
