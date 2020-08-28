module Twitch
  module Kraken
    class Users

      include Initializable

      attr_accessor :id, :name, :display_name, :type, :bio, :logo, :created_at, :updated_at

      class << self

        # Gets a specified user object
        def get_user_by_id(id)
          response = Twitch.client.get(:kraken, "users/#{id}")

          new(response)
        end

        # Gets the user objects for the specified Twitch login names
        def get_users(username)
          response = Twitch.client.get(:kraken, "users?login=#{username}")

          if response["users"].count >= 1
            new(response["users"].first)
          else
            raise Twitch::Errors::NotFound
          end
        end

      end

    end
  end
end
