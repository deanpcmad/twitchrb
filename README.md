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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deanpcmad/twitchrb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
