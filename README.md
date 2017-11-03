[![Build Status](https://travis-ci.org/pioneerworks/yelp-business.svg?branch=master)](https://travis-ci.org/pioneerworks/yelp-business)

[![Maintainability](https://api.codeclimate.com/v1/badges/0ddd76e19c265107cd3e/maintainability)](https://codeclimate.com/github/pioneerworks/yelp-business/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/0ddd76e19c265107cd3e/test_coverage)](https://codeclimate.com/github/pioneerworks/yelp-business/test_coverage)

# Yelp::Business

This is the simple data model encapsulating Yelp Business data received over [Fusion V3 API](https://www.yelp.com/developers/documentation/v3/business).

## Usage

### Configure

First we need to configure the [access token](https://www.yelp.com/developers/documentation/v3/authentication):

You can set the token either prorammatiacally (in ruby), or usin an external environment variable `YELP_ACCESS_TOKEN`.

```bash
export YELP_ACCESS_TOKEN='5eUZNOPOlWw9oQHowSKaYcWQK......'
```

Or, in ruby:

```ruby
# Set the token either directly on +Yelp+ module:
Yelp.access_token = '5eUZNOPOlWw9oQHowSKaYcWQK....'

# or using #configure method on Yelp::Business
Yelp::Business.configure do |config|
  config.access_token = token
end
```

### Fetch Business Info

Next, we'll fetch and cache business info. In your code, when you have business id or URL:

```ruby
require 'yelp/business'

url  = 'https://www.yelp.com/biz/gary-danko-san-francisco'
name = Yelp::Business.business_id_from(url) # => 'gary-danko-san-francisco'

# initialize the object, and also fetch the data from Yelp
business  = Yelp::Business.new(name).get

# You can now call methods on the instance to access it's attributes:
business.name   # => 'Gary Danko'
business.rating #=> 4.5
```

You can also cache the results of the call:

```ruby
cache_key  = "yelp.business.#{business_id}"
business   = Rails.cache.fetch(cache_key) do 
  Yelp::Business.new(business_id).get
end
business.name #=> 'Gary Danko'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yelp-business'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yelp-business


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/pioneerworks/yelp-business](https://github.com/pioneerworks/yelp-business).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
