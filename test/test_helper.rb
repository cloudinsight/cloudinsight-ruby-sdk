# encoding: utf-8

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/setup'
require 'oneapm_ci'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

