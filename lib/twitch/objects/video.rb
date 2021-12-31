module Twitch
  class Video < Object

    def initialize(options = {})
      super options

      self.thumbnail_url_large = generate_thumbnail_url_large
      self.animated_url = generate_animated_url
    end


    # Generates the Large Thumbnail image URL
    def generate_thumbnail_url_large
      return "" if thumbnail_url.empty?

      thumbnail_url.gsub("%{width}", "640").gsub("%{height}", "360")
    end
  
    # Generates a Storyboard/Animated image URL
    def generate_animated_url
      return "" if thumbnail_url.empty?
      
      thumb = thumbnail_url.dup
      thumb.gsub!("https://static-cdn.jtvnw.net/cf_vods/", "").gsub!("/thumb/thumb0-%{width}x%{height}.jpg", "storyboards/#{id}-strip-0.jpg")
      split = thumb.split("/")
  
      "https://#{split[0]}.cloudfront.net/#{split[1..].join("/")}"
    end

  end
end
