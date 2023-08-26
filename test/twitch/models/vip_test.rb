require "test_helper"

class VipTest < Minitest::Test

  def test_vip_list
    vips = Twitch::Vip.list(broadcaster_id: 72938118)

    assert_equal Twitch::Collection, vips.class
    assert_equal Twitch::Vip, vips.data.first.class
    assert_equal "fremily", vips.data.first.user_login
  end

  def test_vip_create
    vip = Twitch::Vip.create(broadcaster_id: 72938118, user_id: 943007443)

    assert vip
  end

  def test_vip_delete
    user = Twitch::Vip.delete(broadcaster_id: 72938118, user_id: 943007443)

    assert user
  end

end
