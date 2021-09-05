# TwitchRB

**This library is a work in progress**

TwitchRB is a Ruby library for intereacting with the Twitch API.

It only supports the Helix API as v5 is deprecated.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "twitchrb", require: "twitch"
```

## Usage

### Set Client Details

Firstly you'll need to set a Client ID, Secret Key and an Access Token.

An access token is required because the Helix API requires authentication.

```ruby
@client = Twitch::Client.new(client_id: "", secret_key: "", access_token: "")
```

### Users

```ruby
@client.users.get_by_id(user_id: 141981764)
@client.users.get_by_username(username: "twitchdev")
```

### Channels

```ruby
@client.channels.get(broadcaster_id: 141981764)
```

### Videos

```ruby
@client.videos.get(user_id: 141981764)
```

### Emotes

```ruby
@client.emotes.global
@client.emotes.channel(broadcaster_id: 141981764)
@client.emotes.sets(emote_set_id: 301590448)
```

### Badges

```ruby
@client.badges.global
@client.badges.channel(broadcaster_id: 141981764)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/twitchrb/twitchrb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
