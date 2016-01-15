require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'cucumber'
require 'cucumber/rake/task'
require 'photish/rake/task'
require 'metric_fu'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  tags = ['']
  tags << '--tags ~@wip'
  tags << '--tags @smoke' if ENV['SMOKE_TEST_ONLY']
  t.cucumber_opts = "features --format pretty #{tags.join(' ')}"
end

desc 'Gather code climate results'
task :gather_coverage do
  next unless ENV['COVERAGE']
  require 'simplecov'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter::Formatter.new.format(SimpleCov.result)
end

desc 'Clean output folders'
task :clean do
  FileUtils.rm_rf('coverage')
end

desc 'Release a new version'
task :bump do
  system("mvim -f lib/photish/version.rb") || abort('Error updating version'.red)
  system("git add lib/photish/version.rb") || abort('Error adding verison'.red)
  system("git commit") || abort("Error creating commit".red)
  system("git diff-index --quiet HEAD") || abort("Uncommited changes".red)
  system("rake release:source_control_push")
end

task :default => [:clean,
                  :spec,
                  :features,
                  :gather_coverage]

task :stats => ['metrics:all']

namespace :photish do
  Photish::Rake::Task.new(:init, 'Creates a basic project') do |t|
    t.options = "init"
  end

  Photish::Rake::Task.new(:generate, 'Generates all the code') do |t|
    t.options = "generate"
  end

  Photish::Rake::Task.new(:host, 'Starts a HTTP and hosts the code') do |t|
    t.options = "host"
  end

  task :all => [:init, :generate, :host]
end
