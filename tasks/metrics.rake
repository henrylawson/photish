require 'metric_fu'

desc 'Gather code climate results'
task :gather_coverage do
  next unless ENV['COVERAGE']
  require 'simplecov'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter::Formatter.new.format(SimpleCov.result)
end

task :stats => ['metrics:all']
