# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yelp/business/version'

Gem::Specification.new do |spec|
  spec.name          = 'yelp-business'
  spec.version       = Yelp::Business::VERSION
  spec.authors       = ['Konstantin Gredeskoul', 'Tim Cannady']
  spec.email         = %w(kigster@gmail.com tim@joinhomebase.com)

  spec.summary       = 'Provides and easy to use model wrapping Yelp Business'
  spec.description   = 'Provides and easy to use model wrapping Yelp Business'

  spec.homepage      = 'https://github.com/pioneerworks/yelp-business'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  #spec.add_dependency 'dry-configurable'
  spec.add_dependency 'yelp'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
