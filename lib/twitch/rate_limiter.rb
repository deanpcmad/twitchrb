module Twitch
  class RateLimiter
    # Twitch API rate limit header names
    LIMIT_HEADER = "ratelimit-limit".freeze
    REMAINING_HEADER = "ratelimit-remaining".freeze
    RESET_HEADER = "ratelimit-reset".freeze

    attr_reader :limit, :remaining, :reset_at, :logger

    def initialize(logger: nil)
      @limit = nil
      @remaining = nil
      @reset_at = nil
      @logger = logger
      @last_warn_at = nil
    end

    # Update rate limit info from response headers
    def update(response_headers)
      return unless response_headers

      @limit = response_headers[LIMIT_HEADER]&.to_i
      @remaining = response_headers[REMAINING_HEADER]&.to_i
      @reset_at = response_headers[RESET_HEADER]&.to_i
    end

    # Check if we're approaching the rate limit
    def approaching_limit?(threshold: 10)
      return false if remaining.nil? || limit.nil?

      remaining <= threshold
    end

    # Get seconds until rate limit resets
    def reset_in
      return nil if reset_at.nil?

      seconds = reset_at - Time.now.to_i
      [ seconds, 0 ].max  # Ensure non-negative
    end

    # Check if rate limited (no remaining requests)
    def rate_limited?
      remaining == 0
    end

    # Log rate limit warning if approaching threshold
    def warn_if_approaching(threshold: 10)
      return unless approaching_limit?(threshold: threshold)
      return unless logger
      return if recently_warned?

      @last_warn_at = Time.now
      logger.warn(
        "Twitch API rate limit approaching: #{remaining}/#{limit} requests remaining. " \
        "Resets in #{reset_in} seconds."
      )
    end

    # Wait if rate limited, with exponential backoff
    def wait_if_rate_limited(base_wait: 1.0, max_wait: 60.0)
      return if !rate_limited? || reset_in.nil?

      wait_seconds = [ reset_in + 1, max_wait ].min  # Add 1 second buffer

      if logger
        logger.warn("Rate limited. Waiting #{wait_seconds} seconds until reset at #{Time.at(reset_at)}")
      end

      sleep(wait_seconds)
    end

    # Reset rate limit tracking
    def reset
      @limit = nil
      @remaining = nil
      @reset_at = nil
      @last_warn_at = nil
    end

    # Get formatted status string
    def status
      if limit.nil? || remaining.nil?
        "Rate limit info not available"
      else
        "#{remaining}/#{limit} requests remaining"
      end
    end

    private

    def recently_warned?
      return false if @last_warn_at.nil?

      # Don't warn more than once per minute
      (Time.now - @last_warn_at) < 60
    end
  end
end
