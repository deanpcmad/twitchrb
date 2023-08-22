require "faraday"
require "json"
require "twitch/version"

module Twitch

  autoload :Configuration, "twitch/configuration"
  autoload :Client, "twitch/client"
  autoload :Collection, "twitch/collection"
  autoload :Error, "twitch/error"
  autoload :Object, "twitch/object"

  class << self
    attr_writer :config
  end

  def self.configure
    yield(config) if block_given?
  end

  def self.config
    @config ||= Twitch::Configuration.new
  end

  autoload :User, "twitch/models/user"
  autoload :Channel, "twitch/models/channel"
  autoload :Emote, "twitch/models/emote"
  autoload :Badge, "twitch/models/badge"
  autoload :Game, "twitch/models/game"
  autoload :Video, "twitch/models/video"
  autoload :Clip, "twitch/models/clip"
  autoload :EventSubSubscription, "twitch/models/event_sub_subscription"
  autoload :BannedEvent, "twitch/models/banned_event"
  autoload :BannedUser, "twitch/models/banned_user"
  autoload :Moderator, "twitch/models/moderator"
  autoload :ModeratorEvent, "twitch/models/moderator_event"
  autoload :Poll, "twitch/models/poll"
  autoload :Prediction, "twitch/models/prediction"
  autoload :StreamSchedule, "twitch/models/stream_schedule"
  autoload :Search, "twitch/models/search"
  autoload :Stream, "twitch/models/stream"
  autoload :StreamMarker, "twitch/models/stream_marker"
  autoload :Subscription, "twitch/models/subscription"
  autoload :Tag, "twitch/models/tag"
  autoload :CustomReward, "twitch/models/custom_reward"
  autoload :CustomRewardRedemption, "twitch/models/custom_reward_redemption"
  autoload :Goal, "twitch/models/goal"
  autoload :HypeTrainEvent, "twitch/models/hype_train_event"
  autoload :Announcement, "twitch/models/announcement"
  autoload :Raid, "twitch/models/raid"
  autoload :ChatMessage, "twitch/models/chat_message"
  autoload :Vip, "twitch/models/vip"
  autoload :Whisper, "twitch/models/whisper"
  autoload :Automod, "twitch/models/automod"
  autoload :BlockedTerm, "twitch/models/blocked_term"
  autoload :CharityCampaign, "twitch/models/charity_campaign"
  autoload :Chatter, "twitch/models/chatter"
  autoload :Shoutout, "twitch/models/shoutout"

  # Extra models, with no API endpoints
  autoload :UserColour, "twitch/models/extra/user_colour"
  autoload :FollowCount, "twitch/models/extra/follow_count"
  autoload :SubscriptionCount, "twitch/models/extra/subscription_count"
  autoload :ChannelEditor, "twitch/models/extra/channel_editor"

end
