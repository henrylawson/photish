require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.command_name 'rspec'
SimpleCov.start CodeClimate::TestReporter.configuration.profile

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'photish'
require 'photish/log/logger'
require 'photish/config/settings'
require 'photish/config/location'
require 'photish/config/file_config'
require 'photish/gallery/album'
require 'photish/gallery/photo'
require 'photish/gallery/collection'
require 'photish/gallery/image'
require 'photish/rake/task'

require 'rspec-html-matchers'

def fixture_file(path)
  File.join(File.dirname(__FILE__), 'fixtures', path)
end

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end
