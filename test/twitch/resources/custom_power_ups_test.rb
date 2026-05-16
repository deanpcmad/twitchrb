require "test_helper"

class CustomPowerUpsResourceTest < Minitest::Test
  def test_custom_power_ups_list_returns_collection
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/bits/custom_power_ups") do |env|
        assert_equal({ "broadcaster_id" => "123" }, env.params)

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            data: [
              {
                id: "power-up-1",
                broadcaster_id: "123",
                title: "Confetti Cannon",
                bits_cost: 100,
                is_enabled: true
              }
            ],
            pagination: {}
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    power_ups = client.custom_power_ups.list(broadcaster_id: "123")

    assert_instance_of Twitch::Collection, power_ups
    assert power_ups.data.all? { |power_up| power_up.is_a?(Twitch::CustomPowerUp) }
    assert_equal "power-up-1", power_ups.first.id
  end

  def test_custom_power_ups_list_supports_id_filter
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/bits/custom_power_ups") do |env|
        assert_equal(
          { "broadcaster_id" => "123", "id" => [ "power-up-1", "power-up-2" ] },
          env.params
        )

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            data: [
              { id: "power-up-1", broadcaster_id: "123", title: "Confetti Cannon", bits_cost: 100, is_enabled: true },
              { id: "power-up-2", broadcaster_id: "123", title: "Spotlight", bits_cost: 250, is_enabled: false }
            ],
            pagination: {}
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    power_ups = client.custom_power_ups.list(broadcaster_id: "123", ids: [ "power-up-1", "power-up-2" ])

    assert_instance_of Twitch::Collection, power_ups
    assert_equal 2, power_ups.data.count
    assert_equal "Spotlight", power_ups.last.title
  end
end
