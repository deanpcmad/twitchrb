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
      return true if response.status == 204
      return response unless error?(response)

      raise_error(response)
    end

    def error?(response)
      [ 400, 401, 403, 404, 409, 429, 500, 501, 503 ].include?(response.status) ||
        response.body&.key?("error")
    end

    def raise_error(response)
      error = Twitch::ErrorFactory.create(response.body, response.status)
      raise error if error
    end
  end
end
