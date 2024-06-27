module Twitch
  class Collection
    attr_reader :data, :total, :cursor

    def self.from_response(response, type:)
      body = response.body

      new(
        data: body["data"].map { |attrs| type.new(attrs) },
        total: body["data"].count,
        cursor: body.dig("pagination", "cursor")
      )
    end

    def initialize(data:, total:, cursor:)
      @data = data
      @total = total
      @cursor = cursor.nil? ? nil : cursor
    end

    def each(&block)
      data.each(&block)
    end

    def first
      data.first
    end

    def last
      data.last
    end
  end
end
