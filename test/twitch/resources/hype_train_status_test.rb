require "test_helper"

class HypeTrainStatusResourceTest < Minitest::Test
  def test_hype_train_status_retrieve_returns_object
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/hypetrain/status") do |env|
        assert_equal({ "broadcaster_id" => "123" }, env.params)

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            data: [
              {
                current: {
                  id: "train-1",
                  broadcaster_user_id: "123",
                  level: 2
                },
                shared_all_time_high: {
                  level: 5,
                  total: 9001
                }
              }
            ]
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    status = client.hype_train_status.retrieve(broadcaster_id: "123")

    assert_instance_of Twitch::HypeTrainStatus, status
    assert_equal "train-1", status.current.id
    assert_equal 5, status.shared_all_time_high.level
  end

  def test_hype_train_status_retrieve_returns_nil_when_none_exist
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/hypetrain/status") do
        [ 200, { "content-type" => "application/json" }, JSON.dump(data: []) ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    assert_nil client.hype_train_status.retrieve(broadcaster_id: "123")
  end

  def test_hype_train_events_list_warns_and_proxies_to_status
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/hypetrain/status") do |env|
        assert_equal({ "broadcaster_id" => "123" }, env.params)

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(data: [ { current: { id: "train-1" } } ])
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    warning = capture_io do
      status = client.hype_train_events.list(broadcaster_id: "123")
      assert_instance_of Twitch::HypeTrainStatus, status
      assert_equal "train-1", status.current.id
    end.last

    assert_includes warning, "`hype_train_events.list` is deprecated"
  end
end
