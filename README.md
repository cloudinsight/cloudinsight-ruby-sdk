# OneapmCi

Sdk for oneapm ci.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oneapm_ci'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oneapm_ci


## Quick Start Guide

```ruby
    require 'oneapm_ci'

    statsd = OneapmCi::Statsd.new

    # Increment a counter.
    statsd.increment('page.views')

    #Record a gauge 50% of the time.
    statsd.gauge('users.online', 100, ['users.onapm'], 0.5)
end