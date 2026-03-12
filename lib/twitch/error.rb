module Twitch
  class Error < StandardError
  end

  class UnsafeRequestPathError < ArgumentError
  end
end
