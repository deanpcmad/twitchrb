require "httparty"

module Twitch
  class Client

    # def initialize(client_id, client_secret, access_token=nil)
    def initialize(client_id)
      puts "initialize"

      @client_id = client_id

      # if client_id && client_secret
      #   @client_id = client_id
      #   @client_secret = client_secret
      #   @access_token = access_token
      # else
      #   raise Twitch::ClientError.new('Client ID or Client Secret not set')
      # end

    end


    def get(kind, url, params={})
      # puts url
      # puts params
      # puts @client_id
      response = HTTParty.get("https://api.twitch.tv/#{kind}/#{url}", {
        headers: {
          "Client-ID" => @client_id,
          "Accept" => "application/vnd.twitchtv.v5+json",
          # "Authorization" => "OAuth #{@access_token}"
        }
      })
      # puts response

      # JSON.parse(response.body)

      success = case response.code
      when 200
        JSON.parse(response.body)
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


      # if response.code == 200
      #   JSON.parse(response.body)
      # elsif response.code == 404
      #   Twitch::NotFoundError.new(response.body)
      # elsif response.code == 500
      #   Twitch::ServerError.new(response.body)
      # end



      # when Net::HTTPClientError
      #   json = JSON.parse(http_result.body)
      #   raise Twitch::Errors::ValidationError, json['errors'].to_s
      # else
      #   raise Twitch::Errors::CommunicationError, http_result.body
      # end


    end


    # private

    # def request(method, path, options={})
    #   # if @access_token



    # end


  end
end
