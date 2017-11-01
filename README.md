# Yelp::Business

This is the simple data model encapsulating Yelp Business data received over [Fusion V3 API](https://www.yelp.com/developers/documentation/v3/business).

## Usage

### Configure

First we need to configure the access token:

```ruby
# this goes into the Rails Initiaizer 
# config/initializers/yelp.rb
require 'yelp/business'
Yelp::Business.configure do |config|
  config.access_token = '..' 
  config.base_url = 'https://api.yelp.com/v3/businesses/{id}'
end
```

### Fetch Business Info

Next, we'll fetch and cache business info. In your code, when you have business id or URL:

```ruby
business_url = 'https://www.yelp.com/biz/gary-danko-san-francisco'
cache_key = "#{current_company.id}.#{business_url}"

require 'yelp/business'
business = Rails.cache.fetch(cache_key) do 
  Yelp::Business.new(access_token: token, business: identifier)
end

# You can then add methods to the internal
Company.new(2134).yelp_business #=> 
 
business.rating #=> 4.5
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
