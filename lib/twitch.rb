require "faraday"
require "faraday_middleware"
require "json"
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
  autoload :ChannelsResource, "twitch/resources/channels"
  autoload :EmotesResource, "twitch/resources/emotes"
  autoload :BadgesResource, "twitch/resources/badges"
  autoload :GamesResource, "twitch/resources/games"
  autoload :VideosResource, "twitch/resources/videos"
  autoload :ClipsResource, "twitch/resources/clips"
  autoload :EventSubSubscriptionsResource, "twitch/resources/event_sub_subscriptions"
  autoload :BannedEventsResource, "twitch/resources/banned_events"
  autoload :BannedUsersResource, "twitch/resources/banned_users"
  autoload :ModeratorsResource, "twitch/resources/moderators"
  autoload :ModeratorEventsResource, "twitch/resources/moderator_events"
  autoload :PollsResource, "twitch/resources/polls"
  autoload :PredictionsResource, "twitch/resources/predictions"
  autoload :StreamScheduleResource, "twitch/resources/stream_schedule"
  autoload :SearchResource, "twitch/resources/search"


  autoload :User, "twitch/objects/user"
  autoload :FollowedUser, "twitch/objects/followed_user"
  autoload :BlockedUser, "twitch/objects/blocked_user"

  autoload :Channel, "twitch/objects/channel"
  autoload :ChannelEditor, "twitch/objects/channel_editor"
  autoload :Emote, "twitch/objects/emote"
  autoload :Badge, "twitch/objects/badge"
  autoload :Game, "twitch/objects/game"
  autoload :Video, "twitch/objects/video"
  autoload :Clip, "twitch/objects/clip"
  autoload :EventSubSubscription, "twitch/objects/event_sub_subscription"
  autoload :BannedEvent, "twitch/objects/banned_event"
  autoload :BannedUser, "twitch/objects/banned_user"
  autoload :Moderator, "twitch/objects/moderator"
  autoload :ModeratorEvent, "twitch/objects/moderator_event"
  autoload :Poll, "twitch/objects/poll"
  autoload :Prediction, "twitch/objects/prediction"
  autoload :StreamSchedule, "twitch/objects/stream_schedule"
  autoload :SearchResult, "twitch/objects/search_result"

end
