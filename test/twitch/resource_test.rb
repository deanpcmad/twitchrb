require "test_helper"

class ResourceTest < Minitest::Test
  class TestResource < Twitch::Resource
    def get(url)
      send(:get_request, url)
    end
  end

  def setup
    super
    @client = Twitch::Client.new(client_id: "123", access_token: "abc123")
    @resource = TestResource.new(@client)
  end

  def test_rejects_protocol_relative_request_paths
    error = assert_raises(Twitch::UnsafeRequestPathError) do
      @resource.get("//evil.example/steal")
    end

    assert_equal "request path must be relative to the Twitch API base URL", error.message
  end

  def test_rejects_absolute_request_paths
    assert_raises(Twitch::UnsafeRequestPathError) do
      @resource.get("https://evil.example/steal")
    end
  end
end
