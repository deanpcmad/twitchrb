require "test_helper"

class AnnouncementTest < Minitest::Test

  def test_announcement_create
    announcement = Twitch::Announcement.create(broadcaster_id: 943007443, moderator_id: 943007443, message: "Test announcement", color: "blue")

    assert announcement
  end

end
