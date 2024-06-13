module Twitch
  class TagsResource < Resource
    def list(**params)
      response = get_request("tags/streams", params: params)
      Collection.from_response(response, type: Tag)
    end

    def stream(broadcaster_id:, **params)
      response = get_request("streams/tags", params: params.merge(broadcaster_id: broadcaster_id))
      Collection.from_response(response, type: Tag)
    end

    # Required scope: channel:manage:broadcast
    def replace(broadcaster_id:, **params)
      put_request("streams/tags", body: params.merge(broadcaster_id: broadcaster_id))
    end
  end
end
