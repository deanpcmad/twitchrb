module Twitch
  module Models
    class Badge

      include Initializable

      attr_accessor :id, :image_url_1x, :image_url_2x, :image_url_4x

    end
  end
end
