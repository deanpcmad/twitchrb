require "test_helper"

class ClipsRequestTest < Minitest::Test
  def test_clips_create_uses_query_params
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("https://api.twitch.tv/helix/clips") do |env|
        assert_equal(
          {
            "broadcaster_id" => "123",
            "title" => "Best moment",
            "duration" => "12.5"
          },
          env.params
        )
        assert_equal "{}", env.body

        [
          202,
          { "content-type" => "application/json" },
          JSON.dump(data: [ { id: "clip-1", edit_url: "https://clips.twitch.tv/clip-1/edit" } ])
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    clip = client.clips.create(broadcaster_id: "123", title: "Best moment", duration: 12.5)

    assert_instance_of Twitch::Clip, clip
    assert_equal "clip-1", clip.id
  end

  def test_clips_create_from_vod_uses_query_params
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("https://api.twitch.tv/helix/videos/clips") do |env|
        assert_equal(
          {
            "editor_id" => "321",
            "broadcaster_id" => "123",
            "vod_id" => "vod-1",
            "vod_offset" => "45",
            "duration" => "15.0",
            "title" => "VOD highlight"
          },
          env.params
        )
        assert_equal "{}", env.body

        [
          202,
          { "content-type" => "application/json" },
          JSON.dump(data: [ { id: "clip-2", edit_url: "https://clips.twitch.tv/clip-2/edit" } ])
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    clip = client.clips.create_from_vod(
      editor_id: "321",
      broadcaster_id: "123",
      vod_id: "vod-1",
      vod_offset: 45,
      duration: 15.0,
      title: "VOD highlight"
    )

    assert_instance_of Twitch::Clip, clip
    assert_equal "clip-2", clip.id
  end

  def test_clips_downloads_returns_collection
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("https://api.twitch.tv/helix/clips/downloads") do |env|
        assert_equal(
          {
            "editor_id" => "321",
            "broadcaster_id" => "123",
            "clip_id" => [ "clip-1", "clip-2" ]
          },
          env.params
        )

        [
          200,
          { "content-type" => "application/json" },
          JSON.dump(
            data: [
              {
                clip_id: "clip-1",
                landscape_download_url: "https://cdn.example/clip-1.mp4",
                portrait_download_url: nil
              },
              {
                clip_id: "clip-2",
                landscape_download_url: "https://cdn.example/clip-2.mp4",
                portrait_download_url: "https://cdn.example/clip-2-portrait.mp4"
              }
            ]
          )
        ]
      end
    end

    client = Twitch::Client.new(client_id: "123", access_token: "abc123", adapter: :test)
    client.instance_variable_set(:@stubs, stubs)

    downloads = client.clips.downloads(
      editor_id: "321",
      broadcaster_id: "123",
      clip_ids: [ "clip-1", "clip-2" ]
    )

    assert_instance_of Twitch::Collection, downloads
    assert downloads.data.all? { |download| download.is_a?(Twitch::ClipDownload) }
    assert_equal "https://cdn.example/clip-1.mp4", downloads.first.landscape_download_url
    assert_equal "https://cdn.example/clip-2-portrait.mp4", downloads.last.portrait_download_url
  end
end
