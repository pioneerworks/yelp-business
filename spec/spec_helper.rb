require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'yelp/business'
require 'rspec/its'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  unless ENV['CI']
    config.filter_run_excluding ci_only: true
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
