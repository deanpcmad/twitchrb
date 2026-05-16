require "test_helper"

class AnnouncementsResourceTest < Minitest::Test
  def test_announcements_create_supports_for_source_only
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("https://api.twitch.tv/helix/chat/announcements") do |env|
        assert_equal(
          { "broadcaster_id" => "123", "moderator_id" => "321" },
          env.params
        )

        body = JSON.parse(env.body)
        assert_equal "test message", body["message"]
        assert_equal "purple", body["color"]
        assert_equal false, body["for_source_only"]

        [ 204, {}, "" ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    assert client.announcements.create(
      broadcaster_id: "123",
      moderator_id: "321",
      message: "test message",
      color: "purple",
      for_source_only: false
    )
  end
end
