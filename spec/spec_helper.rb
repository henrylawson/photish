require 'simplecov'
SimpleCov.command_name 'rspec'
SimpleCov.root(File.join(File.expand_path(File.dirname(__FILE__)), '..'))

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'photish'
require 'rspec-html-matchers'

def fixture_file(path)
  File.join(File.dirname(__FILE__), 'fixtures', path)
end

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end
