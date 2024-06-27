module Twitch
  class Client
    BASE_URL = "https://api.twitch.tv/helix"

    attr_reader :client_id, :access_token, :adapter

    def initialize(client_id:, access_token:, adapter: Faraday.default_adapter)
      @client_id = client_id
      @access_token = access_token
      @adapter = adapter
    end

    def users
      UsersResource.new(self)
    end

    def channels
      ChannelsResource.new(self)
    end

    def emotes
      EmotesResource.new(self)
    end

    def badges
      BadgesResource.new(self)
    end

    def games
      GamesResource.new(self)
    end

    def videos
      VideosResource.new(self)
    end

    def clips
      ClipsResource.new(self)
    end

    def eventsub_subscriptions
      EventsubSubscriptionsResource.new(self)
    end

    def eventsub_conduits
      EventsubConduitsResource.new(self)
    end

    def banned_events
      BannedEventsResource.new(self)
    end

    def banned_users
      BannedUsersResource.new(self)
    end

    def moderators
      ModeratorsResource.new(self)
    end

    def moderator_events
      ModeratorEventsResource.new(self)
    end

    def polls
      PollsResource.new(self)
    end

    def predictions
      PredictionsResource.new(self)
    end

    def stream_schedule
      StreamScheduleResource.new(self)
    end

    def search
      SearchResource.new(self)
    end

    def streams
      StreamsResource.new(self)
    end

    def stream_markers
      StreamMarkersResource.new(self)
    end

    def subscriptions
      SubscriptionsResource.new(self)
    end

    def tags
      TagsResource.new(self)
    end

    def custom_rewards
      CustomRewardsResource.new(self)
    end

    def custom_reward_redemptions
      CustomRewardRedemptionsResource.new(self)
    end

    def goals
      GoalsResource.new(self)
    end

    def hype_train_events
      HypeTrainEventsResource.new(self)
    end

    def announcements
      AnnouncementsResource.new(self)
    end

    def raids
      RaidsResource.new(self)
    end

    def chat_messages
      ChatMessagesResource.new(self)
    end

    def vips
      VipsResource.new(self)
    end

    def whispers
      WhispersResource.new(self)
    end

    def automod
      AutomodResource.new(self)
    end

    def blocked_terms
      BlockedTermsResource.new(self)
    end

    def charity_campaigns
      CharityCampaignsResource.new(self)
    end

    def chatters
      ChattersResource.new(self)
    end

    def shoutouts
      ShoutoutsResource.new(self)
    end

    def unban_requests
      UnbanRequestsResource.new(self)
    end

    def warnings
      WarningsResource.new(self)
    end

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.request :authorization, :Bearer, access_token

        conn.headers = {
          "User-Agent" => "twitchrb/v#{VERSION} (github.com/deanpcmad/twitchrb)",
          "Client-ID": client_id
        }

        conn.request :json

        conn.response :json, content_type: "application/json"

        conn.adapter adapter, @stubs
      end
    end
  end
end
