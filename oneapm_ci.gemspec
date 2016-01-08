# encoding: utf-8

$:.push "#{File.expand_path('..', __FILE__)}/lib"

require 'oneapm_ci/version'

Gem::Specification.new do |gem|
  gem.name          = 'oneapm_ci'
  gem.version       = OneapmCi::VERSION
  gem.authors       = 'oneapm'
  gem.email         = 'support@oneapm.com'

  gem.summary       = 'OneApm Cloud Insight SDK'
  gem.description   = 'OneApm Cloud Insight SDK. (http://www.oneapm.com/ci/feature.html)'
  gem.homepage      = 'http://www.oneapm.com/ci/feature.html'

  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test\/|bin\/|Rakefile)}) }

  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 1.9'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'minitest-reporters', '~> 1.0'
  gem.add_development_dependency 'mocha', '~> 0.13'
  gem.add_development_dependency 'pry', '~> 0.9'
end
