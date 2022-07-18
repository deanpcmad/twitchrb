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
@client = Twitch::Client.new(client_id: "", access_token: "")
```

### Users

```ruby
# Retrieves a user by their ID
@client.users.get_by_id(user_id: 141981764)

# Retrieves a user by their username
@client.users.get_by_username(username: "twitchdev")

# Update the currently authenticated user's description
# Required scope: user:edit
@client.users.update(description: "New Description")

# Shows users who follow or are following a user ID
@client.users.follows(from_id: 141981764)
@client.users.follows(to_id: 141981764)

# A quick method for seeing if a user is following a channel
@client.users.following?(from_id: 141981764, to_id: 141981764)

# Returns Blocked users for a broadcaster
# Required scope: user:read:blocked_users
@client.users.blocks(broadcaster_id: 141981764)

# Blocks a user
# Required scope: user:manage:blocked_users
@client.users.block_user(target_user_id: 141981764)

# Unblocks a user
# Required scope: user:manage:blocked_users
@client.users.unblock_user(target_user_id: 141981764)

# Get a User's Chat Color
@client.users.get_color(user_id: 123)

# Or get multiple users' chat colors
# Returns a collection
@client.users.get_color(user_ids: "123,321")

# Update a User's Chat Color
# Requires user:manage:chat_color
# user_id must be the currently authenticated user
# Current allowed colours: blue, blue_violet, cadet_blue, chocolate, coral, dodger_blue, firebrick, golden_rod, green, hot_pink, orange_red, red, sea_green, spring_green, yellow_green
# For Turbo and Prime users, a hex colour code is allowed.
@client.users.update_color(user_id: 123, color: "blue")
```

### Channels

```ruby
# Retrieve a channel by their ID
@client.channels.get(broadcaster_id: 141981764)

# Retrieve the number of Followers a broadcaster has
@client.channels.follows_count(broadcaster_id: 141981764)

# Retrieve the number of Subscribers and Subscriber Points a broadcaster has
# Required scope: channel:read:subscriptions
@client.channels.subscribers_count(broadcaster_id: 141981764)

# Update the currently authenticated channel details
# Required scope: channel:manage:broadcast
# Parameters which are allowed: game_id, title, broadcaster_language, delay
attributes = {title: "My new title"}
@client.channels.update(broadcaster_id: 141981764, attributes)

# Retrieves editors for a channel
@client.channels.editors(broadcaster_id: 141981764)
```

### Videos

```ruby
# Retrieves a list of videos
# Available parameters: id, user_id or game_id
@client.videos.list(id: 12345)
@client.videos.list(user_id: 12345)
@client.videos.list(game_id: 12345)
```

### Clips

```ruby
# Retrieves a list of clips
# Available parameters: id, broadcaster_id or game_id
@client.clips.list(id: 12345)
@client.clips.list(user_id: 12345)
@client.clips.list(game_id: 12345)

# Retrieves a clip by its ID.
# Clip IDs are alphanumeric. e.g. AwkwardHelplessSalamanderSwiftRage
@client.clips.retrieve(id: "AwkwardHelplessSalamanderSwiftRage")

# Create a clip of a given Channel
# Required scope: clips:edit
@client.clips.create(broadcaster_id: 1234)
```

### Emotes

```ruby
# Retrieve all global emotes
@client.emotes.global

# Retrieve emotes for a channel
@client.emotes.channel(broadcaster_id: 141981764)

# Retrieve emotes for an emote set
@client.emotes.sets(emote_set_id: 301590448)
```

### Badges

```ruby
# Retrieve all global badges
@client.badges.global

# Retrieve badges for a channel
@client.badges.channel(broadcaster_id: 141981764)
```

### Games

```ruby
# Retrieves a game by its ID
@client.games.get_by_id(game_id: 123)

# Retrieves a game by its Name
@client.games.get_by_id(name: "Battlefield 4")

# Retrieves a list of top games
@client.games.top
```

## EventSub Subscriptions

These require an application OAuth access token.  

```ruby
# Retrieves a list of EventSub Subscriptions
# Available parameters: status, type, after
@client.eventsub_subscriptions.list
@client.eventsub_subscriptions.list(status: "enabled")
@client.eventsub_subscriptions.list(type: "channel.follow")

# Create an EventSub Subscription
@client.eventsub_subscriptions.create(
  type: "channel.follow",
  version: 1,
  condition: {broadcaster_user_id: 123},
  transport: {method: "webhook", callback: "webhook_url", secret: "secret"}
)

# Delete an EventSub Subscription
# IDs are UUIDs
@client.eventsub_subscriptions.delete(id: "abc12-abc12-abc12")
```

## Banned Events

```ruby
# Retrieves all ban and un-ban events for a channel
# Available parameters: user_id
@client.banned_events.list(broadcaster_id: 123)
```

## Banned Users

```ruby
# Retrieves all banned and timed-out users for a channel
# Available parameters: user_id
@client.banned_users.list(broadcaster_id: 123)
```

```ruby
# Ban/Timeout a user from a broadcaster's channel
# Required scope: moderator:manage:banned_users
# A reason is required
# To time a user out, a duration is required. If no duration is set, the user will be banned.
@client.banned_users.create broadcaster_id: 123, moderator_id: 321, user_id: 112233, reason: "testing", duration: 60
```

```ruby
# Unban/untimeout a user from a broadcaster's channel
# Required scope: moderator:manage:banned_users
@client.banned_users.delete broadcaster_id: 123, moderator_id: 321, user_id: 112233
```

## Send Chat Announcement

```ruby
# Sends an announcement to the broadcaster's chat room
# Requires moderator:manage:announcements
# moderator_id can be either the currently authenticated moderator or the broadcaster
# color can be either blue, green, orange, purple, primary. If left blank, primary is default
@client.announcements.create broadcaster_id: 123, moderator_id: 123, message: "test message", color: "purple"
```

## Moderators

```ruby
# List all moderators for a broadcaster
# Required scope: moderation:read
# broadcaster_id must be the currently authenticated user
@client.moderators.list broadcaster_id: 123
```

```ruby
# Add a Moderator
# Required scope: channel:manage:moderators
# broadcaster_id must be the currently authenticated user
@client.moderators.create broadcaster_id: 123, user_id: 321
```

```ruby
# Remove a Moderator
# Required scope: channel:manage:moderators
# broadcaster_id must be the currently authenticated user
@client.moderators.delete broadcaster_id: 123, user_id: 321
```

## VIPs

```ruby
# List all VIPs for a broadcaster
# Required scope: channel:read:vips or channel:manage:vips
# broadcaster_id must be the currently authenticated user
@client.vips.list broadcaster_id: 123
```

```ruby
# Add a VIP
# Required scope: channel:manage:vips
# broadcaster_id must be the currently authenticated user
@client.vips.create broadcaster_id: 123, user_id: 321
```

```ruby
# Remove a VIP
# Required scope: channel:manage:vips
# broadcaster_id must be the currently authenticated user
@client.vips.delete broadcaster_id: 123, user_id: 321
```

## Raids

```ruby
# Starts a raid 
# Requires channel:manage:raids
# from_broadcaster_id must be the authenticated user
@client.raids.create from_broadcaster_id: 123, to_broadcaster_id: 321
```

```ruby
# Requires channel:manage:raids
# broadcaster_id must be the authenticated user
@client.raids.delete broadcaster_id: 123
```

```ruby
# Removes a single chat message from the broadcaster's chat room
# Requires moderator:manage:chat_messages
# moderator_id can be either the currently authenticated moderator or the broadcaster
@client.chat_messages.delete broadcaster_id: 123, moderator_id: 123, message_id: "abc123-abc123"
```

## Whispers

```ruby
# Send a Whisper
# Required scope: user:manage:whispers
# from_user_id must be the currently authenticated user's ID and have a verified phone number
@client.whispers.create from_user_id: 123, to_user_id: 321, message: "this is a test"
```

## AutoMod

```ruby
# Check if a message meets the channel's AutoMod requirements
# Required scope: moderation:read
# id is a developer-generated identifier for mapping messages to results.
@client.automod.check_status_multiple broadcaster_id: 123, id: "abc123", text: "Is this message allowed?"

#> #<Twitch::AutomodStatus msg_id="abc123", is_permitted=true>
```

```ruby
# Check if multiple messages meet the channel's AutoMod requirements
# messages must be an array of hashes and must include msg_id and msg_text
# Returns a collection
messages = [{msg_id: "abc1", msg_text: "is this allowed?"}, {msg_id: "abc2", msg_text: "What about this?"}]
@client.automod.check_status_multiple broadcaster_id: 123, messages: messages
```

```ruby
# Get AutoMod settings
# Required scope: moderator:read:automod_settings
# moderator_id can be either the currently authenticated moderator or the broadcaster
@client.automod.settings broadcaster_id: 123, moderator_id: 321
```

```ruby
# Update AutoMod settings
# Required scope: moderator:manage:automod_settings
# moderator_id can be either the currently authenticated moderator or the broadcaster
# As this is a PUT method, it overwrites all options so all fields you want set should be supplied
@client.automod.update_settings broadcaster_id: 123, moderator_id: 321, swearing: 1
```

## Creator Goals

```ruby
# List all active creator goals
# Required scope: channel:read:goals
# broadcaster_id must match the currently authenticated user
@client.goals.list broadcaster_id: 123
```

## Blocked Terms

```ruby
# List all blocked terms
# Required scope: moderator:read:blocked_terms
# moderator_id can be either the currently authenticated moderator or the broadcaster
@client.blocked_terms.list broadcaster_id: 123, moderator_id: 321
```

```ruby
# Create a blocked term
# Required scope: moderator:manage:blocked_terms
# moderator_id can be either the currently authenticated moderator or the broadcaster
@client.blocked_terms.create broadcaster_id: 123, moderator_id: 321, text: "term to block"
```

```ruby
# Delete a blocked term
# Required scope: moderator:manage:blocked_terms
# moderator_id can be either the currently authenticated moderator or the broadcaster
@client.blocked_terms.delete broadcaster_id: 123, moderator_id: 321, id: "abc12-12abc"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/twitchrb/twitchrb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
