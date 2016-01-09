require 'codeclimate-test-reporter'

SimpleCov.start(CodeClimate::TestReporter.configuration.profile) do
  filters.clear

  root(File.expand_path(File.dirname(__FILE__)))

  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/) unless src.filename =~ /photish/
  end
  add_filter '/gems/photish'
  add_filter '/bin/'
  add_filter '/coverage/'
  add_filter '/exe/'
  add_filter '/log/'
  add_filter '/pkg/'
  add_filter 'vendor'
  add_filter 'tmp'

  add_group 'Library',  'lib'
  add_group 'Specs',    'spec'
  add_group 'Features', ['features', 'tmp/aruba']
end if RUBY_ENGINE == 'ruby'
