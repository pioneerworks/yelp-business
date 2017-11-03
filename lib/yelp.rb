require 'yelp/business/version'

module Yelp

  class BaseError < StandardError; end
  class BusinessNotFoundError < BaseError; end
  class InvalidIdentifierError < BaseError; end
  class MissingAccessTokenError < BaseError; end
  class YelpError < BaseError; end
  class AuthenticationError < YelpError; end

  API_HOST          = 'https://api.yelp.com'
  BUSINESS_PATH     = '/v3/businesses/'
  REVIEWS_SUFFIX     = '/reviews'
  PUBLIC_URL_PREFIX = 'https://www.yelp.com/biz/'

  class << self
    attr_accessor :access_token
  end

  self.access_token ||= ENV['YELP_ACCESS_TOKEN']
end


require 'yelp/business'
