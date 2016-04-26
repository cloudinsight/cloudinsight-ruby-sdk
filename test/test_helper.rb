# encoding: utf-8

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/setup'
require 'cloudinsight-sdk'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
