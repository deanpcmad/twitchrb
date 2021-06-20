module Twitch
  module Models
    class Poll

      include Initializable

      attr_accessor :id, :broadcaster_id, :broadcaster_name, :broadcaster_login, :choices
      attr_accessor :bits_voting_enabled, :bits_per_vote, :channel_points_voting_enabled
      attr_accessor :channel_points_per_vote, :status, :duration, :started_at

      def poll_choices
        choices.map {|c| Twitch::Models::PollChoice.new(c)}
      end

    end
  end
end
