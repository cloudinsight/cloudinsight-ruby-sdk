# encoding: utf-8

$LOAD_PATH.push "#{File.expand_path('..', __FILE__)}/lib"

require 'cloud_insight/version'

Gem::Specification.new do |gem|
  gem.name          = 'cloudinsight-sdk'
  gem.version       = CloudInsight::VERSION
  gem.authors       = 'cloudinsight'
  gem.email         = 'support@oneapm.com'

  gem.licenses      = %w(CloudInsight MIT Ruby)
  gem.summary       = 'Cloud Insight SDK'
  gem.description   = 'Cloud Insight SDK. (http://www.oneapm.com/ci/feature.html)'
  gem.homepage      = 'http://www.oneapm.com/ci/feature.html'

  gem.files         = Dir['lib/**/*.rb', 'examples/**/*.rb']

  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 1.9'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'minitest-reporters', '~> 1.0'
  gem.add_development_dependency 'mocha', '~> 0.13'
  gem.add_development_dependency 'pry', '~> 0.9'
  gem.add_development_dependency 'rubocop', '~> 0.39'
end
