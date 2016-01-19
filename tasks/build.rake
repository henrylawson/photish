require 'bundler'
require 'photish/version'

desc "Build all"
task :build => ['build:gem',
                'build:linux:x86',
                'build:linux:x86_64',
                'build:osx',
                'build:win32']

namespace :build do
  desc "Clean up install files"
  task :clean do
    sh "rm -rf #{TaskConfig::BINARY_DIR}/*tar"
    sh "rm -rf #{TaskConfig::BINARY_DIR}/*zip"
    sh "rm -rf #{TaskConfig::BINARY_DIR}/*gem"
  end

  desc "Create GEM file"
  task :gem do
    sh "mkdir -p #{TaskConfig::BINARY_DIR}"
    sh "gem build photish.gemspec"
    sh "mv photish*.gem #{TaskConfig::BINARY_DIR}"
  end

  namespace :linux do
    desc "Package your app for Linux x86"
    task :x86 => [:bundle_install, "#{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-linux-x86.tar.gz"] do
      create_package("linux-x86", :unix)
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install, "#{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz"] do
      create_package("linux-x86_64", :unix)
    end
  end

  desc "Package your app for OS X"
  task :osx => [:bundle_install, "#{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-osx.tar.gz"] do
    create_package("osx", :unix)
  end

  desc "Package your app for Windows x86"
  task :win32 => [:bundle_install, "#{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-win32.tar.gz"] do
    create_package("win32", :windows)
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^#{TaskConfig::EXPECTED_RUBY_VERSION.sub('.', '\.')}/
      abort "You can only 'bundle install' using Ruby 2.1, because that's what Traveling Ruby uses."
    end
    sh "rm -rf #{TaskConfig::SCRATCH_DIR}"
    sh "mkdir -p #{TaskConfig::SCRATCH_DIR}"
    sh "cp Gemfile Gemfile.lock #{TaskConfig::SCRATCH_DIR}"
    new_contents = File.read("#{TaskConfig::SCRATCH_DIR}/Gemfile").gsub(/^gemspec.*$/, "gemspec path: '#{TaskConfig::WORKING_DIR || '../../../'}'")
    File.open("#{TaskConfig::SCRATCH_DIR}/Gemfile", "w") {|file| file.puts(new_contents) }
    Bundler.with_clean_env do
      sh "cd #{TaskConfig::SCRATCH_DIR} && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
    end
    sh "rm -f #{TaskConfig::TEMP_DIR}/vendor/*/*/cache/*"

    sh "rm -rf #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/test"
    sh "rm -rf #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/tests"
    sh "rm -rf #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/spec"
    sh "rm -rf #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/features"
    sh "rm -rf #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/benchmark"

    sh "rm -f #{TaskConfig::TEMP_DIR}/vendor/ruby/*/rdoc*"
    sh "rm -f #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/ext/Makefile"
    sh "rm -f #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/ext/*/Makefile"
    sh "rm -f #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/ext/*/tmp"
    sh "rm -f #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems/*/ext/*/tmp"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby -name '*.c' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby -name '*.cpp' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby -name '*.h' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby -name '*.rl' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby -name 'extconf.rb' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby -name '*.java' | xargs rm -f"
    sh "find #{TaskConfig::TEMP_DIR}/vendor/ruby -name '*.class' | xargs rm -f"
  end
end

file "#{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-win32.tar.gz" do
  download_runtime("win32")
end

file "#{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-linux-x86.tar.gz" do
  download_runtime("linux-x86")
end

file "#{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime("linux-x86_64")
end

file "#{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-osx.tar.gz" do
  download_runtime("osx")
end

def package_dir_of(target)
  "#{Photish::NAME}-#{Photish::VERSION}-#{target}"
end

def create_package(target, os_type)
  package_dir = package_dir_of(target)
  sh "rm -rf #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"
  sh "cp -rf lib #{package_dir}/lib/app/"
  sh "cp -rf exe #{package_dir}/lib/app/"
  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf #{TaskConfig::RELEASES_DIR}/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
  if os_type == :unix
    sh "cp packaging/wrapper.sh #{package_dir}/photish"
    sh "chmod +x #{package_dir}/photish"
  else
    sh "cp packaging/wrapper.bat #{package_dir}/photish.bat"
  end
  sh "cp -pR #{TaskConfig::TEMP_DIR}/vendor #{package_dir}/lib/"

  sh "cp photish.gemspec #{package_dir}/lib/app"
  new_contents = File.read("#{package_dir}/lib/app/photish.gemspec").gsub(/spec\.files.*$/, "spec.files = ''")
  File.open("#{package_dir}/lib/app/photish.gemspec", "w") {|file| file.puts(new_contents) }

  new_contents = File.read("#{TaskConfig::SCRATCH_DIR}/Gemfile").gsub(/^gemspec.*$/, "gemspec path: '../app'")
  File.open("#{TaskConfig::SCRATCH_DIR}/Gemfile", "w") {|file| file.puts(new_contents) }
  sh "cp #{TaskConfig::SCRATCH_DIR}/Gemfile #{TaskConfig::SCRATCH_DIR}/Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp #{TaskConfig::PACKAGING_DIR}/bundler-config #{package_dir}/lib/vendor/.bundle/config"
  if !ENV['DIR_ONLY']
    sh "mkdir -p #{TaskConfig::BINARY_DIR}"
    if os_type == :unix
      sh "tar -czf #{TaskConfig::BINARY_DIR}/#{package_dir}.tar.gz #{package_dir}"
    else
      sh "zip -9r #{TaskConfig::BINARY_DIR}/#{package_dir}.zip #{package_dir}"
    end
    sh "rm -rf #{package_dir}"
  end
end

def download_runtime(target)
  sh "mkdir -p #{TaskConfig::RELEASES_DIR}"
  sh "cd #{TaskConfig::RELEASES_DIR} && curl -L -O --fail " +
     "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{TaskConfig::TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end

def update_after_install_script(package_dir)
  new_contents = File.read("#{TaskConfig::PACKAGING_DIR}/after-install.sh").gsub(/PACKAGE_PLACEHOLDER/, package_dir)
  sh "mkdir -p #{TaskConfig::TEMP_DIR}"
  File.open("#{TaskConfig::TEMP_DIR}/after-install.sh", "w") {|file| file.puts(new_contents) }
  "#{TaskConfig::TEMP_DIR}/after-install.sh"
end
