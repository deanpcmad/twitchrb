require "faraday"
require "json"
require "twitch/version"

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
  autoload :StreamsResource, "twitch/resources/streams"
  autoload :StreamMarkersResource, "twitch/resources/stream_markers"
  autoload :SubscriptionsResource, "twitch/resources/subscriptions"
  autoload :TagsResource, "twitch/resources/tags"
  autoload :CustomRewardsResource, "twitch/resources/custom_rewards"
  autoload :CustomRewardRedemptionsResource, "twitch/resources/custom_reward_redemptions"
  autoload :GoalsResource, "twitch/resources/goals"
  autoload :HypeTrainEventsResource, "twitch/resources/hype_train_events"


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
  autoload :Stream, "twitch/objects/stream"
  autoload :StreamMarker, "twitch/objects/stream_marker"
  autoload :Subscription, "twitch/objects/subscription"
  autoload :SubscriptionCount, "twitch/objects/subscription_count"
  autoload :Tag, "twitch/objects/tag"
  autoload :CustomReward, "twitch/objects/custom_reward"
  autoload :CustomRewardRedemption, "twitch/objects/custom_reward_redemption"
  autoload :Goal, "twitch/objects/goal"
  autoload :HypeTrainEvent, "twitch/objects/hype_train_event"
  autoload :FollowCount, "twitch/objects/follow_count"

end
