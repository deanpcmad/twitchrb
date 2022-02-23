# require "test_helper"

# class ChannelsResourceTest < Minitest::Test
#   def test_info
#     stub = stub_request("channels", response: stub_response(fixture: "channels/get"))
#     client   = Twitch::Client.new(client_id: "123", client_secret: "abc", access_token: "abc123", adapter: :test, stubs: stub)
#     channels = client.channels.get(broadcaster_id: 141981764)

#     assert_equal Twitch::Channel, channels.data.first
#     assert_equal "twitchdev", channels.data.first.broadcaster_login
#   end
# end
