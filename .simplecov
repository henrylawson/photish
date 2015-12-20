require 'codeclimate-test-reporter'

SimpleCov.start(CodeClimate::TestReporter.configuration.profile) do
  add_filter '/bin/'
  add_filter '/coverage/'
  add_filter '/exe/'
  add_filter '/features/'
  add_filter '/log/'
  add_filter '/pkg/'
  add_filter '/spec/'
  add_filter '/tmp/'
end
