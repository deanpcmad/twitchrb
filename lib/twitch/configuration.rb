module Twitch
  class Configuration
    attr_accessor :dev_mode, :client_id, :client_secret, :access_token
    attr_writer :api_url, :oauth_url

    def initialize
      @dev_mode = false
      @api_url = nil
      @oauth_url = nil
      @client_id = nil
      @client_secret = nil
      @access_token = nil
    end

    def api_url
      @api_url || "https://api.twitch.tv/helix"
    end

    def oauth_url
      @oauth_url || "https://id.twitch.tv/oauth2"
    end

    def reset!
      @dev_mode = false
      @api_url = nil
      @oauth_url = nil
      @client_id = nil
      @client_secret = nil
      @access_token = nil
    end
  end
end
