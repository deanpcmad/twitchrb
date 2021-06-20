module Twitch
  module Models
    class Channel

      include Initializable

      attr_accessor :broadcaster_id, :broadcaster_name, :game_name, :game_id
      attr_accessor :broadcaster_language, :title, :delay

    end
  end
end
