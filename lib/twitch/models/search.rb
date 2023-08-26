module Twitch
  class Search < Object

    class << self

      def categories(query:, **params)
        response = Client.get_request("search/categories", params: params.merge(query: query))

        Collection.from_response(response, type: SearchResult)
      end

      def channels(query:, **params)
        response = Client.get_request("search/channels", params: params.merge(query: query))

        Collection.from_response(response, type: SearchResult)
      end

    end

  end
end
