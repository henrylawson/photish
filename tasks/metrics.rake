require 'metric_fu'

desc 'Static code metrics'
task :metrics => ['metrics:all',
                  'metrics:gather_coverage']

namespace :metrics do
  desc 'Clean output folders'
  task :clean do
    FileUtils.rm_rf('coverage')
  end

  desc 'Gather code climate results'
  task :gather_coverage do
    next unless ENV['COVERAGE']
    require 'simplecov'
    require 'codeclimate-test-reporter'
    CodeClimate::TestReporter::Formatter.new.format(SimpleCov.result)
  end
end
