require 'ostruct'
require 'json'
require 'http'
require 'colored2'

require_relative '../yelp'

module Yelp
  class Business
    class << self
      def configure
        Yelp.instance_eval do
          yield(self)
        end
      end

      def business_id_from(url)
        url.gsub %r[.*/], ''
      end
    end

    attr_accessor :data,
                  :business_url,
                  :business_id,
                  :api_url

    def initialize(business_id = nil)
      raise ::Yelp::InvalidIdentifierError, 'business ID can not be nil' if business_id.nil?
      self.business_id  = business_id
      self.business_url = PUBLIC_URL_PREFIX + business_id
      self.api_url      = API_HOST + BUSINESS_PATH + self.business_id if self.business_id
      self.reviews_api_url = API_HOST + BUSINESS_PATH + self.business_id if self.business_id + BUSINESS_REVIEWS_SUFFIX
    end


    # usage: @business.fetch do |data|
    #   data.name #=> 'Gary Danko'
    # end
    def fetch
      unless self.data
        raise ::Yelp::MissingAccessTokenError, 'please specify authentication token as class variable' unless access_token
        self.data = OpenStruct.new(exec_api_call)
        raise ::Yelp::BusinessNotFoundError "Can't find business #{business_id}" unless data
      end
      yield(self.data) if block_given?
      self
    end

    alias get fetch

    def get_reviews
      self.data = OpenStruct.new(reviews_api_fetch)
    end

    def exec_api_call
      raise ::Yelp::MissingAccessTokenError unless access_token
      response = api_fetch
      if response['error']
        raise ::Yelp::AuthenticationError, 'Invalid access token' if response['error']['code'] == 'TOKEN_INVALID'
        raise ::Yelp::BusinessNotFoundError, "Business #{business_id} was not found" if response['error']['description'] =~ /could not be found/
        raise ::Yelp::YelpError, "Yelp returned error: #{response['error']['description']}"
      end
      response
    rescue Exception => e
      error "ERROR:   while fetching data for business #{business_id.bold.green} from #{api_url.yellow}"
      error "DETAILS: #{e.message.bold.red}"
      error(*e.backtrace) if ENV['DEBUG']
      raise e
    end

    def error(*args)
      STDERR.puts args.join("\n")
    end

    def api_fetch
      HTTP.
        auth(bearer_token).
        get(api_url).parse
    end

    def reviews_api_fetch
      HTTP.
        auth(bearer_token).
        get(reviews_api_url).parse
    end

    def bearer_token
      "Bearer #{access_token}"
    end

    def access_token
      Yelp.access_token
    end

    def method_missing(method, *args, &block)
      data.send(method, *args, &block)
    end
  end
end
