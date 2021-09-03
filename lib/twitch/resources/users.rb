module Twitch
  class UsersResource < Resource
    
    def get_by_id(user_id:)
      User.new get_request("users/?id=#{user_id}").body.dig("data")[0]
    end

    def get_by_username(username:)
      User.new get_request("users/?login=#{username}").body.dig("data")[0]
    end

    # Updates the current users description
    # Requires scope: user:edit
    def update(description:)
      response = put_request("users", body: {description: description})
      User.new response.body.dig("data")[0]
    end

  end
end
