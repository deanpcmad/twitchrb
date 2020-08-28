require "time"
require "httparty"
require "json"

require "twitch/version"

require "twitch/client"
require "twitch/initializable"

# Kraken (v5) API
require "twitch/kraken/user"
require "twitch/kraken/users"
require "twitch/kraken/channels"
require "twitch/kraken/clips"

module Twitch

  class << self
    attr_reader :client

    def access_details(client_id)
      @client = Client.new(client_id)
      # @client.access_token = access_token if access_token
    end
  end

  # Error classes to raise
  class Error < StandardError; end
  module Errors
    class ServiceUnavailable < Error; end
    class AccessDenied < Error; end
    class NotFound < Error; end
    class CommunicationError < Error; end
    class ValidationError < Error; end
  end

end
