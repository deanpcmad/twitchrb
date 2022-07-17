module Twitch
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    private

    def get_request(url, params: {}, headers: {})
      handle_response client.connection.get(url, params, headers)
    end

    def post_request(url, body:, headers: {})
      handle_response client.connection.post(url, body, headers)
    end

    def patch_request(url, body:, headers: {})
      handle_response client.connection.patch(url, body, headers)
    end

    def put_request(url, body:, headers: {})
      handle_response client.connection.put(url, body, headers)
    end

    def delete_request(url, params: {}, headers: {})
      handle_response client.connection.delete(url, params, headers)
    end

    def handle_response(response)
      case response.status
      when 400
        raise Error, "Error 400: Your request was malformed. '#{response.body["message"]}'"
      when 401
        raise Error, "Error 401: You did not supply valid authentication credentials. '#{response.body["error"]}'"
      when 403
        raise Error, "Error 403: You are not allowed to perform that action. '#{response.body["error"]}'"
      when 404
        raise Error, "Error 404: No results were found for your request. '#{response.body["error"]}'"
      when 409
        raise Error, "Error 409: Your request was a conflict. '#{response.body["message"]}'"
      when 422
        raise Error, "Error 422: Unprocessable Entity. '#{response.body["message"]}"
      when 429
        raise Error, "Error 429: Your request exceeded the API rate limit. '#{response.body["error"]}'"
      when 500
        raise Error, "Error 500: We were unable to perform the request due to server-side problems. '#{response.body["error"]}'"
      when 503
        raise Error, "Error 503: You have been rate limited for sending more than 20 requests per second. '#{response.body["error"]}'"
      when 204
        # 204 is a response for success on Twitch's API
        return true
      end

      response
    end
  end
end
