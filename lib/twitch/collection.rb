module Twitch
  class Collection
    attr_reader :data, :total, :cursor

    def self.from_response(response, key:, type:)
      body = response.body

      new(
        data: body[key].map { |attrs| type.new(attrs) },
        total: body[key].count,
        cursor: body.dig("pagination", "cursor") 
      )
    end

    def initialize(data:, total:, cursor:)
      @data = data
      @total = total
      @cursor = cursor.nil? ? nil : cursor
    end
  end
end
