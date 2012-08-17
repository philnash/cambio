# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cambio/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Phil Nash"]
  gem.email         = ["philnash@gmail.com"]
  gem.description   = %q{A simple wrapper for the Open Exchange Rates API.
                      https://openexchangerates.org/}
  gem.summary       = %q{A simple wrapper for the Open Exchange Rates API}
  gem.homepage      = "http://github.com/philnash/cambio"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cambio"
  gem.require_paths = ["lib"]
  gem.version       = Cambio::VERSION

  gem.add_development_dependency 'vcr', '~> 2.2.4'
  gem.add_development_dependency 'webmock', '~> 1.8.8'

  gem.add_runtime_dependency 'faraday', '~> 0.8.1'
  gem.add_runtime_dependency 'faraday_middleware', '~> 0.8.8'
  gem.add_runtime_dependency 'hashie', '~> 1.2.0'
end
