require 'pry'
require 'retriable'
require 'uri'
require 'net/http'
require 'anemone'

Before do
  @working_directory = File.join('tmp', 'aruba')
end

def fixture_file(path)
  File.join(File.dirname(__FILE__), '../',  'fixtures', path)
end

