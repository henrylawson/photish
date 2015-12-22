require 'simplecov'
SimpleCov.command_name 'cucumber'
SimpleCov.root(File.join(File.expand_path(File.dirname(__FILE__)), '..', '..'))

require 'pry'
require 'retriable'
require 'uri'
require 'net/http'
require 'anemone'
require 'rspec'

Before do
  set_environment_variable('COVERAGE', 'true')
  @working_directory = File.join('tmp', 'aruba')
  FileUtils.rm_rf(@working_directory)
end

RETRY_OPTIONS = {
  tries: 10,
  base_interval: 1,
  max_interval: 15,
  on: [RSpec::Expectations::ExpectationNotMetError,
       Errno::ECONNREFUSED]
}
