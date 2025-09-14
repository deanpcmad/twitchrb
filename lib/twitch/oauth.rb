module Twitch
  class OAuth
    OAUTH_BASE_URL = "https://id.twitch.tv/oauth2"

    attr_reader :client_id, :client_secret, :dev_mode, :oauth_url

    def initialize(client_id: nil, client_secret: nil, dev_mode: nil, oauth_url: nil)
      @client_id = client_id || Twitch.configuration.client_id
      @client_secret = client_secret || Twitch.configuration.client_secret
      @dev_mode = dev_mode.nil? ? Twitch.configuration.dev_mode : dev_mode
      @oauth_url = oauth_url || Twitch.configuration.oauth_url
    end

    def create(grant_type:, scope: nil)
      send_request(url: "#{oauth_url}/token", body: {
        client_id: client_id,
        client_secret: client_secret,
        grant_type: grant_type,
        scope: scope
      })
    end

    def refresh(refresh_token:)
      send_request(url: "#{oauth_url}/token", body: {
        client_id: client_id,
        client_secret: client_secret,
        grant_type: "refresh_token",
        refresh_token: refresh_token
      })
    end

    def device(scopes:)
      send_request(url: "#{oauth_url}/device", body: { client_id: client_id, scope: scopes })
    end

    def validate(token:)
      response = Faraday.get("#{oauth_url}/validate", nil, { "Authorization" => "OAuth #{token}" })

      return false if response.status != 200

      JSON.parse(response.body, object_class: OpenStruct)
    end

    def revoke(token:)
      response = Faraday.post("#{oauth_url}/revoke", {
        client_id: client_id,
        token: token
      })

      JSON.parse(response.body, object_class: OpenStruct) if response.status != 200

      true
    end

    private

    def send_request(url:, body:)
      response = Faraday.post(url, body)

      return false if response.status != 200

      JSON.parse(response.body, object_class: OpenStruct)
    end
  end
end
