module Twitch
  module Kraken
    class User

      include Initializable

      attr_accessor :id, :name, :display_name, :email, :email_verified, :partnered, :type, :bio, :logo, :created_at, :updated_at

      class << self

        # Gets a user object based on the OAuth token provided
        # Scopes required: user_read
        def get
          response = Twitch.client.get("user")

          new(response)
        end

      end

    end
  end
end
