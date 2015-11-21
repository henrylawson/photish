require 'pry'

Before do
  @working_directory = File.join('tmp', 'aruba')
end

def fixture_file(path)
  File.join(File.dirname(__FILE__), '../',  'fixtures', path)
end

