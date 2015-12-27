require 'simplecov'
SimpleCov.command_name 'cucumber'

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
  max_interval: 30,
  on: [RSpec::Expectations::ExpectationNotMetError,
       Errno::ECONNREFUSED]
}

def change_config
  config_file = File.join(@working_directory, 'config.yml')
  config = YAML.load_file(config_file)
  yield(config)
  File.open(config_file, 'w') { |f| f.write(config.to_yaml) }
  FileUtils.touch(File.join(@working_directory, 'site', 'touchfile'))
end
