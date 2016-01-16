require 'photish/version'

PACKAGE_NAME = "photish"
VERSION = Photish::VERSION
TRAVELING_RUBY_VERSION = "20150715-2.2.2"
BINARY_DIR = 'pkg'
RELEASES_DIR = ENV['RELEASES_DIR'] || 'packaging/releases'

desc "Package your app"
task :package => ['package:linux:x86', 'package:linux:x86_64', 'package:osx']

namespace :package do
  namespace :linux do
    desc "Package your app for Linux x86"
    task :x86 => [:bundle_install, "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz"] do
      create_package("linux-x86")
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install, "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz"] do
      create_package("linux-x86_64")
    end
  end

  desc "Package your app for OS X"
  task :osx => [:bundle_install, "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz"] do
    create_package("osx")
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.2\./
      abort "You can only 'bundle install' using Ruby 2.1, because that's what Traveling Ruby uses."
    end
    sh "rm -rf packaging/tmp"
    sh "mkdir packaging/tmp"
    sh "cp Gemfile Gemfile.lock packaging/tmp/"
    new_contents = File.read('packaging/tmp/Gemfile').gsub(/^gemspec.*$/, "gemspec path: '../../'")
    File.open('packaging/tmp/Gemfile', "w") {|file| file.puts(new_contents) }
    Bundler.with_clean_env do
      sh "cd packaging/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
    end
    sh "rm -f packaging/vendor/*/*/cache/*"
  end
end

file "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz" do
  download_runtime("linux-x86")
end

file "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime("linux-x86_64")
end

file "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz" do
  download_runtime("osx")
end

def create_package(target)
  package_dir = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  sh "rm -rf #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"
  sh "cp -rf lib #{package_dir}/lib/app/"
  sh "cp -rf exe #{package_dir}/lib/app/"
  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf #{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
  sh "cp packaging/wrapper.sh #{package_dir}/photish"
  sh "cp -pR packaging/vendor #{package_dir}/lib/"
  sh "cp photish.gemspec #{package_dir}/lib/app"
  new_contents = File.read('packaging/tmp/Gemfile').gsub(/^gemspec.*$/, "gemspec path: '../app'")
  File.open('packaging/tmp/Gemfile', "w") {|file| file.puts(new_contents) }
  sh "cp packaging/tmp/Gemfile packaging/tmp/Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"
  sh "chmod +x #{package_dir}/photish"
  if !ENV['DIR_ONLY']
    sh "tar -czf #{BINARY_DIR}/#{package_dir}.tar.gz #{package_dir}"
    sh "rm -rf #{package_dir}"
  end
end

def download_runtime(target)
  sh "mkdir -p #{RELEASES_DIR}"
  sh "cd #{RELEASES_DIR} && curl -L -O --fail " +
     "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end
