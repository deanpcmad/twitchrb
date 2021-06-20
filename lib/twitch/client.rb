require "httparty"

module Twitch
  class Client

    # def initialize(client_id, client_secret, access_token=nil)
    def initialize(client_id, access_token=nil)
      puts "initialize"

      @client_id = client_id
      @access_token = access_token

      # if client_id && client_secret
      #   @client_id = client_id
      #   @client_secret = client_secret
      #   @access_token = access_token
      # else
      #   raise Twitch::ClientError.new('Client ID or Client Secret not set')
      # end
    end

    def headers(kind)
      if kind == :helix
        {
          "Client-ID" => @client_id,
          "Accept" => "application/json",
          "Authorization" => "Bearer #{@access_token}"
        }
      else
        {
          "Client-ID" => @client_id,
          "Accept" => "application/vnd.twitchtv.v5+json",
          # "Authorization" => "OAuth #{@access_token}"
        }
      end
    end


    def get(kind, url)
      response = HTTParty.get("https://api.twitch.tv/#{kind}/#{url}", {
        headers: headers(kind)
      })

      # Force encoding as the reponse may have emojis
      body = response.body.force_encoding('UTF-8')

      success = case response.code
      when 200
        JSON.parse(body)
      when 400
        json = JSON.parse(body)
        raise Twitch::Errors::NotFound, json['error']
      when 503
        raise Twitch::Errors::ServiceUnavailable
      when 401, 403
        puts body.inspect
        raise Twitch::Errors::AccessDenied, "Access Denied for '#{@client_id}'"
      when 400
        json = JSON.parse(body)
        raise Twitch::Errors::ValidationError, json['errors'].to_s
      else
        raise Twitch::Errors::CommunicationError, body
      end
    end

    def patch(kind, url, params={})
      response = HTTParty.patch("https://api.twitch.tv/#{kind}/#{url}", {
        headers: headers(kind),
        body: params
      })

      success = case response.code
      when 204
        return true
      when 400
        json = JSON.parse(response.body)
        raise Twitch::Errors::NotFound, json['error']
      when 503
        raise Twitch::Errors::ServiceUnavailable
      when 401, 403
        puts response.body.inspect
        raise Twitch::Errors::AccessDenied, "Access Denied for '#{@client_id}'"
      when 400
        json = JSON.parse(response.body)
        raise Twitch::Errors::ValidationError, json['errors'].to_s
      else
        raise Twitch::Errors::CommunicationError, response.body
      end
    end

  end
end
