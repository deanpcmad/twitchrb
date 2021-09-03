require "faraday"
require "faraday_middleware"
require "twitch/version"

require "twitch/version"

# require "twitch/client"
# require "twitch/initializable"

# # Models
# require "twitch/models/channel"
# require "twitch/models/badge"
# require "twitch/models/game"
# require "twitch/models/emote"
# require "twitch/models/poll"
# require "twitch/models/poll_choice"

# # Helix API
# require "twitch/channels"
# require "twitch/emotes"
# require "twitch/badges"
# require "twitch/games"
# require "twitch/polls"

module Twitch

  autoload :Client, "twitch/client"
  autoload :Collection, "twitch/collection"
  autoload :Error, "twitch/error"
  autoload :Resource, "twitch/resource"
  autoload :Object, "twitch/object"

  autoload :UsersResource, "twitch/resources/users"
  autoload :EmotesResource, "twitch/resources/emotes"
  autoload :BadgesResource, "twitch/resources/badges"

  autoload :User, "twitch/objects/user"
  autoload :Emote, "twitch/objects/emote"
  autoload :Badge, "twitch/objects/badge"

  # class << self
  #   attr_reader :client

  #   def access_details(client_id, access_token=nil)
  #     @client = Client.new(client_id, access_token)
  #     # @client.access_token = access_token if access_token
  #   end
  # end

  # # Error classes to raise
  # class Error < StandardError; end
  # module Errors
  #   class ServiceUnavailable < Error; end
  #   class AccessDenied < Error; end
  #   class NotFound < Error; end
  #   class CommunicationError < Error; end
  #   class ValidationError < Error; end
  # end

end
