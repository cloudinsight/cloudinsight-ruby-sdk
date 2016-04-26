# encoding: utf-8

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/setup'
require 'cloud_insight'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
