require 'codeclimate-test-reporter'

SimpleCov.start(CodeClimate::TestReporter.configuration.profile) do
  filters.clear

  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/) unless src.filename =~ /photish/
  end

  add_filter '/bin/'
  add_filter '/coverage/'
  add_filter '/exe/'
  add_filter '/log/'
  add_filter '/pkg/'
  add_filter '/tmp/'

  add_group 'Library',  'lib'
  add_group 'Specs',    'spec'
  add_group 'Features', 'features'
end
