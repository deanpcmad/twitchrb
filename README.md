# TwitchRB

TwitchRB is a Ruby library for interacting with the Twitch Helix API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "twitchrb"
```

## Usage

### Set Client Details

Firstly you'll need to set a Client ID and an Access Token.

An access token is required because the Helix API requires authentication.

```ruby
Twitch.configure do |config|
  config.client_id    = ENV["TWITCH_CLIENT_ID"]
  config.access_token = ENV["TWITCH_ACCESS_TOKEN"]
end
```

### Users

```ruby
# Retrieves a user by their ID
Twitch::User.retrieve(id: 141981764)

# Retrieves multiple users by their IDs
# Requires an array of IDs
Twitch::User.retrieve(ids: [141981764, 72938118])

# Retrieves a user by their username
Twitch::User.retrieve(username: "twitchdev")

# Retrieves multiple users by their usernames
# Requires an array of IDs
Twitch::User.retrieve(usernames: ["twitchdev", "deanpcmad"])

# Update the currently authenticated user's description
# Required scope: user:edit
Twitch::User.update(description: "New Description")

# Returns Blocked users for a broadcaster
# Required scope: user:read:blocked_users
Twitch::User.blocks(broadcaster_id: 141981764)

# Blocks a user
# Required scope: user:manage:blocked_users
Twitch::User.block_user(target_user_id: 141981764)

# Unblocks a user
# Required scope: user:manage:blocked_users
Twitch::User.unblock_user(target_user_id: 141981764)

# Get a User's Chat Color
Twitch::User.get_colour(id: 123)

# Or get multiple users' chat colors
# Returns a collection
Twitch::User.get_color(user_ids: "123,321")

# Update a User's Chat Color
# Requires user:manage:chat_color
# user_id must be the currently authenticated user
# Current allowed colours: blue, blue_violet, cadet_blue, chocolate, coral, dodger_blue, firebrick, golden_rod, green, hot_pink, orange_red, red, sea_green, spring_green, yellow_green
# For Turbo and Prime users, a hex colour code is allowed.
Twitch::User.update_color(user_id: 123, color: "blue")
```

### Channels

```ruby
# Retrieve a channel by their ID
Twitch::Channel.get(broadcaster_id: 141981764)

# Retrieve a list of broadcasters a specified user follows
# user_id must match the currently authenticated user
# Required scope: user:read:follows
Twitch::Channel.followed user_id: 123123

# Retrieve a list of users that follow a specified broadcaster
# broadcaster_id must match the currently authenticated user or
# a moderator of the specified broadcaster
# Required scope: moderator:read:followers
Twitch::Channel.followers broadcaster_id: 123123

# Retrieve the number of Followers a broadcaster has
Twitch::Channel.follows_count(broadcaster_id: 141981764)

# Retrieve the number of Subscribers and Subscriber Points a broadcaster has
# Required scope: channel:read:subscriptions
Twitch::Channel.subscribers_count(broadcaster_id: 141981764)

# Update the currently authenticated channel details
# Required scope: channel:manage:broadcast
# Parameters which are allowed: game_id, title, broadcaster_language, delay
attributes = {title: "My new title"}
Twitch::Channel.update(broadcaster_id: 141981764, attributes)

# Retrieves editors for a channel
Twitch::Channel.editors(broadcaster_id: 141981764)
```

### Videos

```ruby
# Retrieves a list of videos
# Available parameters: id, user_id or game_id
Twitch::Video.list(id: 12345)
Twitch::Video.list(user_id: 12345)
Twitch::Video.list(game_id: 12345)

# Retrieve a video by its ID
Twitch::Video.retrieve(id: 12345)

# Delete a video
# Required scope: channel:manage:videos
Twitch::Video.delete(id: 12345)
```

### Clips

```ruby
# Retrieves a list of clips
# Available parameters: id, broadcaster_id or game_id
Twitch::Clip.list(id: 12345)
Twitch::Clip.list(user_id: 12345)
Twitch::Clip.list(game_id: 12345)

# Retrieves a clip by its ID.
# Clip IDs are alphanumeric. e.g. AwkwardHelplessSalamanderSwiftRage
Twitch::Clip.retrieve(id: "AwkwardHelplessSalamanderSwiftRage")

# Create a clip of a given Channel
# Required scope: clips:edit
Twitch::Clip.create(broadcaster_id: 1234)
```

### Emotes

```ruby
# Retrieve all global emotes
Twitch::Emote.global

# Retrieve emotes for a channel
Twitch::Emote.channel(broadcaster_id: 141981764)

# Retrieve emotes for an emote set
Twitch::Emote.sets(emote_set_id: 301590448)
```

### Badges

```ruby
# Retrieve all global badges
Twitch::Badge.global

# Retrieve badges for a channel
Twitch::Badge.channel(broadcaster_id: 141981764)
```

### Games

```ruby
# Retrieves a game by its ID
Twitch::Game.get_by_id(game_id: 123)

# Retrieves a game by its Name
Twitch::Game.get_by_id(name: "Battlefield 4")

# Retrieves a list of top games
Twitch::Game.top
```

## EventSub Subscriptions

These require an application OAuth access token.

```ruby
# Retrieves a list of EventSub Subscriptions
# Available parameters: status, type, after
Twitch::EventSubSubscription.list
Twitch::EventSubSubscription.list(status: "enabled")
Twitch::EventSubSubscription.list(type: "channel.follow")

# Create an EventSub Subscription
Twitch::EventSubSubscription.create(
  type: "channel.follow",
  version: 1,
  condition: {broadcaster_user_id: 123},
  transport: {method: "webhook", callback: "webhook_url", secret: "secret"}
)

# Delete an EventSub Subscription
# IDs are UUIDs
Twitch::EventSubSubscription.delete(id: "abc12-abc12-abc12")
```

## Banned Events

```ruby
# Retrieves all ban and un-ban events for a channel
# Available parameters: user_id
Twitch::BannedEvent.list(broadcaster_id: 123)
```

## Banned Users

```ruby
# Retrieves all banned and timed-out users for a channel
# Available parameters: user_id
Twitch::BannedUser.list(broadcaster_id: 123)
```

```ruby
# Ban/Timeout a user from a broadcaster's channel
# Required scope: moderator:manage:banned_users
# A reason is required
# To time a user out, a duration is required. If no duration is set, the user will be banned.
Twitch::BannedUser.create broadcaster_id: 123, moderator_id: 321, user_id: 112233, reason: "testing", duration: 60
```

```ruby
# Unban/untimeout a user from a broadcaster's channel
# Required scope: moderator:manage:banned_users
Twitch::BannedUser.delete broadcaster_id: 123, moderator_id: 321, user_id: 112233
```

## Send Chat Announcement

```ruby
# Sends an announcement to the broadcaster's chat room
# Requires moderator:manage:announcements
# moderator_id can be either the currently authenticated moderator or the broadcaster
# color can be either blue, green, orange, purple, primary. If left blank, primary is default
Twitch::Announcement.create broadcaster_id: 123, moderator_id: 123, message: "test message", color: "purple"
```

## Create a Shoutout

```ruby
# Creates a Shoutout for a broadcaster
# Requires moderator:manage:shoutouts
# From: the ID of the Broadcaster creating the Shoutout
# To: the ID of the Broadcaster the Shoutout will be for
# moderator_id can be either the currently authenticated moderator or the broadcaster
Twitch::Shoutout.create from: 123, to: 321, moderator_id: 123
```

## Moderators

```ruby
# List all moderators for a broadcaster
# Required scope: moderation:read
# broadcaster_id must be the currently authenticated user
Twitch::Moderator.list broadcaster_id: 123
```

```ruby
# Add a Moderator
# Required scope: channel:manage:moderators
# broadcaster_id must be the currently authenticated user
Twitch::Moderator.create broadcaster_id: 123, user_id: 321
```

```ruby
# Remove a Moderator
# Required scope: channel:manage:moderators
# broadcaster_id must be the currently authenticated user
Twitch::Moderator.delete broadcaster_id: 123, user_id: 321
```

## VIPs

```ruby
# List all VIPs for a broadcaster
# Required scope: channel:read:vips or channel:manage:vips
# broadcaster_id must be the currently authenticated user
Twitch::Vip.list broadcaster_id: 123
```

```ruby
# Add a VIP
# Required scope: channel:manage:vips
# broadcaster_id must be the currently authenticated user
Twitch::Vip.create broadcaster_id: 123, user_id: 321
```

```ruby
# Remove a VIP
# Required scope: channel:manage:vips
# broadcaster_id must be the currently authenticated user
Twitch::Vip.delete broadcaster_id: 123, user_id: 321
```

## Raids

```ruby
# Starts a raid
# Requires channel:manage:raids
# from_broadcaster_id must be the authenticated user
Twitch::Raid.create from_broadcaster_id: 123, to_broadcaster_id: 321
```

```ruby
# Requires channel:manage:raids
# broadcaster_id must be the authenticated user
Twitch::Raid.delete broadcaster_id: 123
```

## Chat Messages

```ruby
# Removes a single chat message from the broadcaster's chat room
# Requires moderator:manage:chat_messages
# moderator_id can be either the currently authenticated moderator or the broadcaster
Twitch::ChatMessage.delete broadcaster_id: 123, moderator_id: 123, message_id: "abc123-abc123"
```

## Whispers

```ruby
# Send a Whisper
# Required scope: user:manage:whispers
Twitch::Whisper.create from_user_id: 123, to_user_id: 321, message: "this is a test"
```

## AutoMod

```ruby
# Check if a message meets the channel's AutoMod requirements
# Required scope: moderation:read
# id is a developer-generated identifier for mapping messages to results.
Twitch::Automod.check_status_multiple broadcaster_id: 123, id: "abc123", text: "Is this message allowed?"

#> #<Twitch::AutomodStatus msg_id="abc123", is_permitted=true>
```

```ruby
# Check if multiple messages meet the channel's AutoMod requirements
# messages must be an array of hashes and must include msg_id and msg_text
# Returns a collection
messages = [{msg_id: "abc1", msg_text: "is this allowed?"}, {msg_id: "abc2", msg_text: "What about this?"}]
Twitch::Automod.check_status_multiple broadcaster_id: 123, messages: messages
```

```ruby
# Get AutoMod settings
# Required scope: moderator:read:automod_settings
# moderator_id can be either the currently authenticated moderator or the broadcaster
Twitch::Automod.settings broadcaster_id: 123, moderator_id: 321
```

```ruby
# Update AutoMod settings
# Required scope: moderator:manage:automod_settings
# moderator_id can be either the currently authenticated moderator or the broadcaster
# As this is a PUT method, it overwrites all options so all fields you want set should be supplied
Twitch::Automod.update_settings broadcaster_id: 123, moderator_id: 321, swearing: 1
```

## Creator Goals

```ruby
# List all active creator goals
# Required scope: channel:read:goals
# broadcaster_id must match the currently authenticated user
Twitch::Goal.list broadcaster_id: 123
```

## Blocked Terms

```ruby
# List all blocked terms
# Required scope: moderator:read:blocked_terms
# moderator_id can be either the currently authenticated moderator or the broadcaster
Twitch::BlockedTerm.list broadcaster_id: 123, moderator_id: 321
```

```ruby
# Create a blocked term
# Required scope: moderator:manage:blocked_terms
# moderator_id can be either the currently authenticated moderator or the broadcaster
Twitch::BlockedTerm.create broadcaster_id: 123, moderator_id: 321, text: "term to block"
```

```ruby
# Delete a blocked term
# Required scope: moderator:manage:blocked_terms
# moderator_id can be either the currently authenticated moderator or the broadcaster
Twitch::BlockedTerm.delete broadcaster_id: 123, moderator_id: 321, id: "abc12-12abc"
```

## Charity Campaigns

```ruby
# Gets information about the charity campaign that a broadcaster is running
# Required scope: channel:read:charity
# broadcaster_id must match the currently authenticated user
Twitch::CharityCampaign.list broadcaster_id: 123
```

## Chatters

```ruby
# Gets the list of users that are connected to the specified broadcaster’s chat session
# Required scope: moderator:read:chatters
# broadcaster_id must match the currently authenticated user
Twitch::Chatter.list broadcaster_id: 123, moderator_id: 123
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/twitchrb/twitchrb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
