require "test_helper"

class SubscriptionTest < Minitest::Test

  def test_subscription_list
    subscriptions = Twitch::Subscription.list(broadcaster_id: 72938118)

    assert_equal Twitch::Collection, subscriptions.class
    assert_equal Twitch::Subscription, subscriptions.data.first.class
    assert_equal "deanpcmad", subscriptions.data.first.user_name
  end

  def test_subscription_is_subscribed
    subscriptions = Twitch::Subscription.is_subscribed(broadcaster_id: 13363719, user_id: 72938118)

    assert_equal Twitch::Collection, subscriptions.class
    assert_equal Twitch::Subscription, subscriptions.data.first.class
    assert_equal "13363719", subscriptions.data.first.broadcaster_id
  end

  def test_subscription_counts
    counts = Twitch::Subscription.counts(broadcaster_id: 72938118)

    assert_equal Twitch::SubscriptionCount, counts.class
    assert_equal 6, counts.count
    assert_equal 7, counts.points
  end

end
