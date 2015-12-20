require 'simplecov'
SimpleCov.command_name 'cucumber'
SimpleCov.root(File.join(File.expand_path(File.dirname(__FILE__)), '..', '..'))

require 'pry'
require 'retriable'
require 'uri'
require 'net/http'
require 'anemone'

Before do
  set_environment_variable('COVERAGE', 'true')
  @working_directory = File.join('tmp', 'aruba')
end
