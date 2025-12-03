require "test_helper"

class RateLimiterTest < Minitest::Test
  def setup
    @limiter = Twitch::RateLimiter.new
  end

  def test_initialization
    assert_nil @limiter.limit
    assert_nil @limiter.remaining
    assert_nil @limiter.reset_at
  end

  def test_update_with_headers
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "100",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)

    assert_equal 120, @limiter.limit
    assert_equal 100, @limiter.remaining
    assert_equal (Time.now.to_i + 60), @limiter.reset_at
  end

  def test_update_with_nil_headers
    @limiter.update(nil)
    assert_nil @limiter.limit
  end

  def test_update_with_empty_headers
    @limiter.update({})
    assert_nil @limiter.limit
  end

  def test_approaching_limit_when_below_threshold
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "5",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)

    assert @limiter.approaching_limit?(threshold: 10)
  end

  def test_approaching_limit_when_above_threshold
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "50",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)

    refute @limiter.approaching_limit?(threshold: 10)
  end

  def test_approaching_limit_when_not_initialized
    refute @limiter.approaching_limit?(threshold: 10)
  end

  def test_reset_in_calculation
    reset_time = Time.now.to_i + 60
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "100",
      "ratelimit-reset" => reset_time.to_s
    }

    @limiter.update(headers)
    reset_in = @limiter.reset_in

    assert reset_in >= 59
    assert reset_in <= 60
  end

  def test_reset_in_when_not_set
    assert_nil @limiter.reset_in
  end

  def test_rate_limited_when_remaining_is_zero
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "0",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)

    assert @limiter.rate_limited?
  end

  def test_not_rate_limited_when_remaining_is_positive
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "10",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)

    refute @limiter.rate_limited?
  end

  def test_status_when_not_initialized
    assert_equal "Rate limit info not available", @limiter.status
  end

  def test_status_when_initialized
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "50",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)

    assert_equal "50/120 requests remaining", @limiter.status
  end

  def test_reset_clears_state
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "50",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)
    @limiter.reset

    assert_nil @limiter.limit
    assert_nil @limiter.remaining
    assert_nil @limiter.reset_at
  end

  def test_with_logger
    logger = Logger.new($stdout)
    limiter = Twitch::RateLimiter.new(logger: logger)

    assert_equal logger, limiter.logger
  end

  def test_warn_if_approaching_does_not_warn_without_logger
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "5",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)

    # Should not raise an error
    @limiter.warn_if_approaching(threshold: 10)
  end

  def test_wait_if_rate_limited_with_zero_seconds
    reset_time = Time.now.to_i
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "0",
      "ratelimit-reset" => reset_time.to_s
    }

    @limiter.update(headers)

    # Should wait when rate limited
    @limiter.wait_if_rate_limited(base_wait: 0.01, max_wait: 0.1)
    # Test passes if no exception is raised
  end

  def test_wait_if_rate_limited_respects_max_wait
    reset_time = Time.now.to_i + 10
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "0",
      "ratelimit-reset" => reset_time.to_s
    }

    @limiter.update(headers)

    start_time = Time.now
    @limiter.wait_if_rate_limited(base_wait: 1.0, max_wait: 0.1)
    elapsed = Time.now - start_time

    # Should have waited no more than max_wait + buffer
    assert elapsed < 0.3, "Should have respected max_wait limit"
  end

  def test_wait_if_not_rate_limited
    headers = {
      "ratelimit-limit" => "120",
      "ratelimit-remaining" => "50",
      "ratelimit-reset" => (Time.now.to_i + 60).to_s
    }

    @limiter.update(headers)

    start_time = Time.now
    @limiter.wait_if_rate_limited
    elapsed = Time.now - start_time

    # Should return immediately
    assert elapsed < 0.1
  end
end
