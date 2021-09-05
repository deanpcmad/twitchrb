module Twitch
  class SearchResource < Resource

    def categories(query:, **params)
      response = get_request("search/categories", params: params.merge(query: query))

      Collection.from_response(response, key: "data", type: SearchResult)
    end

    def channels(query:, **params)
      response = get_request("search/channels", params: params.merge(query: query))

      Collection.from_response(response, key: "data", type: SearchResult)
    end
    
  end
end
