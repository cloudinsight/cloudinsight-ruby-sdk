#! /usr/bin/env ruby

require 'cloudinsight-sdk'

statsd = CloudInsight::Statsd.new

# Increment a counter.(default: 1)
statsd.increment('page.views')

# Increment a counter by 5 steps.
statsd.increment('page.views', 5)

# Increment a counter by 5, 50% sample
statsd.increment('page.views', 5, ['page.tag'], 0.5)

# Decrement a counter.
statsd.decrement('page.views')

# Decrement a counter by 5 steps.
statsd.decrement('page.views', 5)

# Decrement a counter by 5, 50% sample
statsd.decrement('page.views', 5, ['page.tag'], 0.5)

# Record a gauge 100 of replies
statsd.gauge('blogs.replies', 100)

# Record a gauge by 100, 50% sample
statsd.gauge('users.online', 100, ['users.cloudinsight'], 0.5)
