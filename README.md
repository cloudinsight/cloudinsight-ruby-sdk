# Cloud Insight Ruby SDK

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'cloudinsight-sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudinsight-sdk


## Quick Start Guide

```ruby
  require 'cloudinsight-sdk'

  statsd = CloudInsight::Statsd.new

  #Increment a counter.
  statsd.increment('page.views')
  
  #Record a gauge 100 of replies
  statsd.gauge('blogs.replies', 100)

  #Record a gauge 50% of the time.
  statsd.gauge('users.online', 100, ['users.cloudinsight'], 0.5)
```

document see: [http://docs-ci.oneapm.com/api/ruby.html](http://docs-ci.oneapm.com/api/ruby.html)