require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.command_name 'rspec'
SimpleCov.start CodeClimate::TestReporter.configuration.profile

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'photish'
require 'rspec-html-matchers'

def fixture_file(path)
  File.join(File.dirname(__FILE__), 'fixtures', path)
end

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end
