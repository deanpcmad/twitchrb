module Twitch
  module Initializable

    def initialize(params = {})
      params.each do |key, value|
        if key == "_id"
          key = "id"
        end

        setter = "#{key}="
        send(setter, value) if respond_to?(setter.to_sym, false)
      end

    end
  end
end
