require 'yelp/business/version'

module Yelp
  class Business
    attr_accessor :data

    def initialize(hash)
      self.data = OpenStruct.new(hash)
    end
  end
end
