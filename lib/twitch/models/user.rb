module Twitch
  class User < Object

    class << self

      def retrieve(id: nil, ids: nil, username: nil, usernames: nil)
        raise "Either id, ids, username or usernames is required" unless !id.nil? || !ids.nil? || !username.nil? || !usernames.nil?

        if id
          response = Client.get_request("users", params: {id: id})
        elsif ids
          response = Client.get_request("users", params: {id: ids})
        elsif usernames
          response = Client.get_request("users", params: {login: usernames})
        else
          response = Client.get_request("users", params: {login: username})
        end

        body = response.body.dig("data")
        if body.count == 1
          User.new body[0]
        elsif body.count > 1
          Collection.from_response(response, type: User)
        else
          return nil
        end
      end

      # Updates the current users description
      # Required scope: user:edit
      def update(description:)
        response = Client.put_request("users", body: {description: description})
        User.new response.body.dig("data")[0]
      end

      def get_colour(id: nil, ids: nil)
        raise "Either id or ids is required" unless !id.nil? || !ids.nil?

        if id
          response = Client.get_request("chat/color", params: {user_id: id})
        elsif ids
          response = Client.get_request("chat/color", params: {user_id: ids})
        end

        body = response.body.dig("data")
        if body.count == 1
          UserColour.new body[0]
        elsif body.count > 1
          Collection.from_response(response, type: UserColour)
        else
          return nil
        end
      end

      # Update a user's color
      # Required scope: user:manage:chat_color
      # user_id must be the currently authenticated user
      def update_color(user_id:, color:)
        put_request("chat/color?user_id=#{user_id}&color=#{color}", body: {})
      end

      # Required scope: user:read:blocked_users
      def blocks(broadcaster_id:, **params)
        response = get_request("users/blocks?broadcaster_id=#{broadcaster_id}", params: params)
        Collection.from_response(response, type: BlockedUser)
      end

      # Required scope: user:manage:blocked_users
      def block_user(target_user_id:, **attributes)
        put_request("users/blocks?target_user_id=#{target_user_id}", body: attributes)
      end

      # Required scope: user:manage:blocked_users
      def unblock_user(target_user_id:)
        delete_request("users/blocks?target_user_id=#{target_user_id}")
      end

      # # A quick method to see if a user is following a channel
      # def following?(from_id:, to_id:)
      #   warn "`users.following?` is deprecated. Use `channels.followers` or `channels.following` instead."

      #   response = get_request("users/follows", params: {from_id: from_id, to_id: to_id})

      #   if response.body["data"].empty?
      #     false
      #   else
      #     true
      #   end
      # end

    end

  end
end
