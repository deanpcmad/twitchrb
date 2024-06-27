# TwitchRB

TwitchRB is the easiest and most complete Ruby library for the [Twitch Helix API](https://dev.twitch.tv/docs/api).

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
@client = Twitch::Client.new(client_id: "abc123", access_token: "xyz123")
```

### Resources

The gem maps as closely as we can to the Twitch API so you can easily convert API examples to gem code.

Responses are created as objects like `Twitch::Channel`. Having types like `Twitch::User` is handy for understanding what
type of object you're working with. They're built using OpenStruct so you can easily access data in a Ruby-ish way.

### Pagination

Some of the endpoints return pages of results. The result object will have a `data` key to access the results, as well as metadata like `cursor`
for retrieving the next and previous pages. This can be used by using `before` and `after` parameters, on API endpoints that support it.

An example of using collections, including pagination:

```ruby
results = @client.clips.list(broadcaster_id: 123)
#=> Twitch::Collection

results.total
#=> 30

results.data
#=> [#<Twitch::Clip>, #<Twitch::Clip>]

results.each do |result|
  puts result.id
end

results.first
#=> #<Twitch::Clip>

results.last
#=> #<Twitch::Clip>

results.cursor
#=> "abc123"

# Retrieve the next page
@client.clips.list(broadcaster_id: 123, after: results.cursor)
#=> Twitch::Collection
```

### OAuth

This library includes the ability to create, refresh and revoke OAuth tokens.

```ruby
# Firstly, set the client details
@oauth = Twitch::OAuth.new(client_id: "", client_secret: "")

# Create a Token
# grant_type can be either "authorization_code" or "client_credentials"
# scope is a space-delimited list of scopes. This is optional depending on the grant_type
@oauth.create(grant_type: "", scope: "")

# Refresh a Token
@oauth.refresh(refresh_token: "")

# Device Code Grant Flow
# scopes is required and is a space-delimited list of scopes
# https://dev.twitch.tv/docs/authentication/getting-tokens-oauth/#device-code-grant-flow
@oauth.device(scopes: "bits:read channel:read:subscriptions")

# Validate an Access Token
# Returns false if the token is invalid
@oauth.validate(token: "")

# Revoke a Token
@oauth.revoke(token: "")
```

### Users

```ruby
# Retrieves a user by their ID
@client.users.retrieve(id: 141981764)

# Retrieves multiple users by their IDs
# Requires an array of IDs
@client.users.retrieve(ids: [141981764, 72938118])

# Retrieves a user by their username
@client.users.retrieve(username: "twitchdev")

# Retrieves multiple users by their usernames
# Requires an array of IDs
@client.users.retrieve(usernames: ["twitchdev", "deanpcmad"])

# Update the currently authenticated user's description
# Required scope: user:edit
@client.users.update(description: "New Description")

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

# Get Emotes a User has
# Required scope: user:read:emotes
@client.users.emotes(user_id: 123)
@client.users.emotes(user_id: 123, broadcaster_id: 321)
@client.users.emotes(user_id: 123, after: "abc123")
```

### Channels

```ruby
# Retrieve a channel by their ID
@client.channels.retrieve(id: 141981764)

# Retrieve a list of broadcasters a specified user follows
# user_id must match the currently authenticated user
# Required scope: user:read:follows
@client.channels.followed user_id: 123123

# Retrieve a list of users that follow a specified broadcaster
# broadcaster_id must match the currently authenticated user or
# a moderator of the specified broadcaster
# Required scope: moderator:read:followers
@client.channels.followers broadcaster_id: 123123

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
# Available parameters: user_id or game_id
@client.videos.list(user_id: 12345)
@client.videos.list(game_id: 12345)

# Retrieves a video by its ID
@client.videos.retrieve(id: 12345)
```

### Clips

```ruby
# Retrieves a list of clips
# Available parameters: broadcaster_id or game_id
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
# Retrieves a game by ID
@client.games.retrieve(id: 514974)

# Retrieves multiple games by IDs
# Requires an array of IDs
@client.games.retrieve(ids: [66402, 514974])

# Retrieves a game by name
@client.games.retrieve(name: "Battlefield 4")

# Retrieves multiple games by names
# Requires an array of IDs
@client.games.retrieve(names: ["Battlefield 4", "Battlefield 2042"])
```

### EventSub Subscriptions

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

### Banned Events

```ruby
# Retrieves all ban and un-ban events for a channel
# Available parameters: user_id
@client.banned_events.list(broadcaster_id: 123)
```

### Banned Users

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

### Send Chat Announcement

```ruby
# Sends an announcement to the broadcaster's chat room
# Requires moderator:manage:announcements
# moderator_id can be either the currently authenticated moderator or the broadcaster
# color can be either blue, green, orange, purple, primary. If left blank, primary is default
@client.announcements.create broadcaster_id: 123, moderator_id: 123, message: "test message", color: "purple"
```

### Create a Shoutout

```ruby
# Creates a Shoutout for a broadcaster
# Requires moderator:manage:shoutouts
# From: the ID of the Broadcaster creating the Shoutout
# To: the ID of the Broadcaster the Shoutout will be for
# moderator_id can be either the currently authenticated moderator or the broadcaster
@client.shoutouts.create from: 123, to: 321, moderator_id: 123
```

### Moderators

```ruby
# List all channels a user has moderator privileges on
# Required scope: user:read:moderated_channels
# user_id must be the currently authenticated user
@client.moderators.channels user_id: 123
```

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

### VIPs

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

### Raids

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

### Chat Messages

```ruby
# Send a chat message to a broadcaster's chat room
# Requires an app or user access token that includes user:write:chat then either user:bot or channel:bot
# sender_id must be the currently authenticated user
# reply_to is optional and is the UUID of the message to reply to
@client.chat_messages.create broadcaster_id: 123, sender_id: 321, message: "A test message", reply_to: "aabbcc"

# Removes a single chat message from the broadcaster's chat room
# Requires moderator:manage:chat_messages
# moderator_id can be either the currently authenticated moderator or the broadcaster
@client.chat_messages.delete broadcaster_id: 123, moderator_id: 123, message_id: "abc123-abc123"
```

### Whispers

```ruby
# Send a Whisper
# Required scope: user:manage:whispers
# from_user_id must be the currently authenticated user's ID and have a verified phone number
@client.whispers.create from_user_id: 123, to_user_id: 321, message: "this is a test"
```

### AutoMod

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

### Creator Goals

```ruby
# List all active creator goals
# Required scope: channel:read:goals
# broadcaster_id must match the currently authenticated user
@client.goals.list broadcaster_id: 123
```

### Blocked Terms

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

### Charity Campaigns

```ruby
# Gets information about the charity campaign that a broadcaster is running
# Required scope: channel:read:charity
# broadcaster_id must match the currently authenticated user
@client.charity_campaigns.list broadcaster_id: 123
```

### Chatters

```ruby
# Gets the list of users that are connected to the specified broadcaster’s chat session
# Required scope: moderator:read:chatters
# broadcaster_id must match the currently authenticated user
@client.chatters.list broadcaster_id: 123, moderator_id: 123
```

### Channel Points Custom Rewards

```ruby
# Gets a list of custom rewards for a specific channel
# Required scope: channel:read:redemptions
# broadcaster_id must match the currently authenticated user
@client.custom_rewards.list broadcaster_id: 123

# Create a custom reward
# Required scope: channel:manage:redemptions
# broadcaster_id must match the currently authenticated user
@client.custom_rewards.create broadcaster_id: 123, title: "New Reward", cost: 1000

# Update a custom reward
# Required scope: channel:manage:redemptions
# broadcaster_id must match the currently authenticated user
@client.custom_rewards.update broadcaster_id: 123, reward_id: 321, title: "Updated Reward"

# Delete a custom reward
# Required scope: channel:manage:redemptions
# broadcaster_id must match the currently authenticated user
@client.custom_rewards.delete broadcaster_id: 123, reward_id: 321
```

### Channel Points Custom Reward Redemptions

```ruby
# Gets a list of custom reward redemptions for a specific channel
# Required scope: channel:read:redemptions
# broadcaster_id must match the currently authenticated user
@client.custom_reward_redemptions.list broadcaster_id: 123, reward_id: 321, status: "UNFULFILLED"

# Update a custom reward redemption status
# Required scope: channel:manage:redemptions
# broadcaster_id must match the currently authenticated user
# Status can be FULFILLED or CANCELED
@client.custom_reward_redemptions.update broadcaster_id: 123, reward_id: 321, redemption_id: 123, status: "FULFILLED"
```

### Unban Requests

```ruby
# Retrieves a list of Unban Requests for a broadcaster
# Required scope: moderator:read:unban_requests or moderator:manage:unban_requests
# moderator_id must match the currently authenticated user
@client.unban_requests.list broadcaster_id: 123, moderator_id: 123, status: "pending"

# Resolve an Unban Request
# Required scope: moderator:manage:unban_requests
# moderator_id must match the currently authenticated user
@client.unban_requests.resolve broadcaster_id: 123, moderator_id: 123, id: "abc123", status: "approved"
```

### Warnings

```ruby
# Sends a warning to a user
# Required scope: moderator:manage:warnings
# moderator_id must match the currently authenticated user
@client.warnings.create broadcaster_id: 123, moderator_id: 123, user_id: 321, reason: "dont do that"
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deanpcmad/twitchrb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
