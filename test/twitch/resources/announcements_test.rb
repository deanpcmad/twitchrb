require "test_helper"

class AnnouncementsResourceTest < WebmockTest
  def setup
    @client = Twitch::Client.new(client_id: "test_client_id", access_token: "test_token")
  end

  def test_announcements_create_supports_for_source_only
    stub_request(:post, "#{HELIX_URL}/chat/announcements")
      .with(
        query: { "broadcaster_id" => "123", "moderator_id" => "321" },
        body: hash_including("message" => "test message", "color" => "purple", "for_source_only" => false)
      )
      .to_return(status: 204, body: "")

    assert @client.announcements.create(
      broadcaster_id: "123",
      moderator_id: "321",
      message: "test message",
      color: "purple",
      for_source_only: false
    )
  end
end
