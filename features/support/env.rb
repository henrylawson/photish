require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.command_name 'cucumber'
SimpleCov.start CodeClimate::TestReporter.configuration.profile

require 'pry'
require 'retriable'
require 'uri'
require 'net/http'
require 'anemone'

Before do
  @working_directory = File.join('tmp', 'aruba')
end
