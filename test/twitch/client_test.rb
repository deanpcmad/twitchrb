require "test_helper"

class ClientTest < Minitest::Test
  def test_client_id
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_equal "123", client.client_id
  end

  def test_access_token
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_equal "abc123", client.access_token
  end

  def test_rate_limiter_initialization
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_instance_of Twitch::RateLimiter, client.rate_limiter
  end

  def test_default_rate_limit_threshold
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_equal 10, client.rate_limit_threshold
  end

  def test_custom_rate_limit_threshold
    client = Twitch::Client.new client_id: "123", access_token: "abc123", rate_limit_threshold: 20
    assert_equal 20, client.rate_limit_threshold
  end

  def test_default_auto_retry_rate_limit
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert client.auto_retry_rate_limit
  end

  def test_disable_auto_retry_rate_limit
    client = Twitch::Client.new client_id: "123", access_token: "abc123", auto_retry_rate_limit: false
    refute client.auto_retry_rate_limit
  end

  def test_logger_configuration
    logger = Logger.new($stdout)
    client = Twitch::Client.new client_id: "123", access_token: "abc123", logger: logger
    assert_equal logger, client.logger
    assert_equal logger, client.rate_limiter.logger
  end

  def test_no_logger_by_default
    client = Twitch::Client.new client_id: "123", access_token: "abc123"
    assert_nil client.logger
  end
end
