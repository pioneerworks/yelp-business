require 'ostruct'
require 'json'
require 'http'
require 'colored2'

require_relative '../yelp'

module Yelp
  class Search
    def initialize(search_params = {})
      @search_api_url = API_HOST + BUSINESS_PATH + SEARCH_SUFFIX + search_params
    end

    def search
      HTTP.auth(bearer_token).get(@search_api_url).parse
    end

    def error(*args)
      STDERR.puts args.join("\n")
    end

    def bearer_token
      "Bearer #{access_token}"
    end

    def access_token
      Yelp.access_token
    end
  end
end
