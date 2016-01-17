require 'photish/version'

PACKAGE_NAME = Photish::NAME
VERSION = Photish::VERSION
EXPECTED_RUBY_VERSION = '2.2.2'
TRAVELING_RUBY_VERSION = "20150715-#{EXPECTED_RUBY_VERSION}"
PACKAGING_DIR = 'packaging'
BINARY_DIR = 'pkg'
TEMP_DIR = ENV['TEMP_DIR'] || 'tmp/packaging'
RELEASES_DIR = "#{TEMP_DIR}/releases"
SCRATCH_DIR = "#{TEMP_DIR}/scratch"

desc "Package your app"
task :package => ['package:clean',
                  'package:linux:x86',
                  'package:linux:x86_64',
                  'package:osx',
                  'package:win32',
                  'package:installer:deb',
                  'package:installer:rpm']

namespace :package do
  task :clean do
    sh "rm -rf #{BINARY_DIR}/*tar"
    sh "rm -rf #{BINARY_DIR}/*deb"
    sh "rm -rf #{BINARY_DIR}/*rpm"
  end

  namespace :installer do
    desc "Create a debian package"
    task :deb do
      create_deb('i386', 'linux-x86')
      create_deb('amd64', 'linux-x86_64')
    end

    task :rpm do
      create_rpm('i386', 'linux-x86')
      create_rpm('x86_64', 'linux-x86_64')
    end
  end

  namespace :linux do
    desc "Package your app for Linux x86"
    task :x86 => [:bundle_install, "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz"] do
      create_package("linux-x86", :unix)
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install, "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz"] do
      create_package("linux-x86_64", :unix)
    end
  end

  desc "Package your app for OS X"
  task :osx => [:bundle_install, "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz"] do
    create_package("osx", :unix)
  end

  desc "Package your app for Windows x86"
  task :win32 => [:bundle_install, "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-win32.tar.gz"] do
    create_package("win32", :windows)
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^#{EXPECTED_RUBY_VERSION.sub('.', '\.')}/
      abort "You can only 'bundle install' using Ruby 2.1, because that's what Traveling Ruby uses."
    end
    sh "rm -rf #{SCRATCH_DIR}"
    sh "mkdir -p #{SCRATCH_DIR}"
    sh "cp Gemfile Gemfile.lock #{SCRATCH_DIR}"
    new_contents = File.read("#{SCRATCH_DIR}/Gemfile").gsub(/^gemspec.*$/, "gemspec path: '../../../'")
    File.open("#{SCRATCH_DIR}/Gemfile", "w") {|file| file.puts(new_contents) }
    Bundler.with_clean_env do
      sh "cd #{SCRATCH_DIR} && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
    end
    sh "rm -f #{TEMP_DIR}/vendor/*/*/cache/*"
  end
end

file "#{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-win32.tar.gz" do
  download_runtime("win32")
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

def package_dir_of(target)
  "#{PACKAGE_NAME}-#{VERSION}-#{target}"
end

def create_package(target, os_type)
  package_dir = package_dir_of(target)
  sh "rm -rf #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"
  sh "cp -rf lib #{package_dir}/lib/app/"
  sh "cp -rf exe #{package_dir}/lib/app/"
  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf #{RELEASES_DIR}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
  if os_type == :unix
    sh "cp packaging/wrapper.sh #{package_dir}/photish"
    sh "chmod +x #{package_dir}/photish"
  else
    sh "cp packaging/wrapper.bat #{package_dir}/photish.bat"
  end
  sh "cp -pR #{TEMP_DIR}/vendor #{package_dir}/lib/"

  sh "cp photish.gemspec #{package_dir}/lib/app"
  new_contents = File.read("#{package_dir}/lib/app/photish.gemspec").gsub(/spec\.files.*$/, "spec.files = ''")
  File.open("#{package_dir}/lib/app/photish.gemspec", "w") {|file| file.puts(new_contents) }

  new_contents = File.read("#{SCRATCH_DIR}/Gemfile").gsub(/^gemspec.*$/, "gemspec path: '../app'")
  File.open("#{SCRATCH_DIR}/Gemfile", "w") {|file| file.puts(new_contents) }
  sh "cp #{SCRATCH_DIR}/Gemfile #{SCRATCH_DIR}/Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp #{PACKAGING_DIR}/bundler-config #{package_dir}/lib/vendor/.bundle/config"
  if !ENV['DIR_ONLY']
    sh "mkdir -p #{BINARY_DIR}"
    if os_type == :unix
      sh "tar -czf #{BINARY_DIR}/#{package_dir}.tar.gz #{package_dir}"
    else
      sh "zip -9r #{BINARY_DIR}/#{package_dir}.zip #{package_dir}"
    end
    sh "rm -rf #{package_dir}"
  end
end

def download_runtime(target)
  sh "mkdir -p #{RELEASES_DIR}"
  sh "cd #{RELEASES_DIR} && curl -L -O --fail " +
     "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end

def update_after_install_script(package_dir)
  new_contents = File.read("#{PACKAGING_DIR}/after-install.sh").gsub(/PACKAGE_PLACEHOLDER/, package_dir)
  File.open("#{TEMP_DIR}/after-install.sh", "w") {|file| file.puts(new_contents) }
  "#{TEMP_DIR}/after-install.sh"
end

def create_deb(architecture, package_architecture)
  package_dir = package_dir_of(package_architecture)
  sh "fpm " + "-s tar " +
              "-t deb " +
              "--deb-no-default-config-files " +
              "--architecture #{architecture} " +
              "--name #{Photish::NAME} " +
              "--vendor \"Foinq\" " +
              "--maintainer \"#{Photish::AUTHOR_NAME} <#{Photish::AUTHOR_EMAIL}>\" " +
              "--version #{VERSION} " +
              "--description \"#{Photish::DESCRIPTION}\" " +
              "--license \"#{Photish::LICENSE}\" " +
              "--prefix \"/usr/local/lib\" " +
              "--after-install #{update_after_install_script(package_dir)} " +
              "--package 'pkg' " +
              "--force " +
              "#{BINARY_DIR}/#{package_dir}.tar.gz"
end

def create_rpm(architecture, package_architecture)
  package_dir = package_dir_of(package_architecture)
  sh "fpm " + "-s tar " +
              "-t rpm " +
              "--rpm-os linux " +
              "--architecture #{architecture} " +
              "--name #{Photish::NAME} " +
              "--vendor \"Foinq\" " +
              "--maintainer \"#{Photish::AUTHOR_NAME} <#{Photish::AUTHOR_EMAIL}>\" " +
              "--version #{VERSION} " +
              "--description \"#{Photish::DESCRIPTION}\" " +
              "--license \"#{Photish::LICENSE}\" " +
              "--prefix \"/usr/local/lib\" " +
              "--epoch \"#{Time.now.to_i}\" " +
              "--after-install #{update_after_install_script(package_dir)} " +
              "--package 'pkg' " +
              "--force " +
              "#{BINARY_DIR}/#{package_dir}.tar.gz"
end
