# TwitchRB

**This library is a work in progress**

TwitchRB is a Ruby library for intereacting with the Twitch Helix API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "twitchrb"
```

## Usage

### Set Client Details

Firstly you'll need to set a Client ID, Secret Key and an Access Token.

An access token is required because the Helix API requires authentication.

```ruby
@client = Twitch::Client.new(client_id: "", client_secret: "", access_token: "")
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

```

### Channels

```ruby
# Retrieve a channel by their ID
@client.channels.get(broadcaster_id: 141981764)

# Retrieve the total followers count for a channel
@client.channels.follows_count(broadcaster_id: 141981764)

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


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/twitchrb/twitchrb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
