# TwitchRB

**This library is a work in progress**

This RubyGem is a library for intereacting with the Twitch API.

It will allow you to easily interact with the Helix API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "twitchrb", require: "twitch"
```

And then execute:

    $ bundle install


## Usage

### Client ID

Firstly you'll need to set a Client ID, and if required, an access token.

```ruby
@client = Twitch::Client.new(client_id: "", secret_key: "", access_token: "")

## Users
@client.users.get_by_id(user_id: 141981764)
@client.users.get_by_username(username: "twitchdev")
```

### Emotes

#### Get Emotes for a Channel

Returns an array of Emotes for a given Channel ID

```ruby
Twitch::Emotes.get_channel(channel_id)
```

```ruby
#<Twitch::Emotes:0x000055c9e6285a68 @id="307523178", @name="deanpcWIZARD", @images={"url_1x"=>"https://static-cdn.jtvnw.net/emoticons/v1/307523178/1.0", "url_2x"=>"https://static-cdn.jtvnw.net/emoticons/v1/307523178/2.0", "url_4x"=>"https://static-cdn.jtvnw.net/emoticons/v1/307523178/3.0"}, @tier="1000", @emote_type="subscriptions", @emote_set_id="304095543">
```

The following methods are available:

- url_1x
- url_2x
- url_4x



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deanpcmad/twitchrb.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
