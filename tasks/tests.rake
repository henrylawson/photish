require "rspec/core/rake_task"
require 'cucumber'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  tags = ['']
  tags << '--tags ~@wip'
  tags << '--tags @smoke' if ENV['SMOKE_TEST_ONLY']
  t.cucumber_opts = "features --format pretty #{tags.join(' ')}"
end
