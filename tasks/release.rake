desc 'Release to all repositories'
task :release => ['release:rubygems',
                  'release:github',
                  'release:bintray']

namespace :release do
  desc 'Release to RubyGems'
  task :rubygems do
    if Pathname.new("~/.gem/credentials").expand_path.exist?
      allowed_push_host = nil
      sh "gem push '#{TaskConfig::BINARY_DIR}/photish-#{Photish::VERSION}.gem'"
    else
      raise "Your rubygems.org credentials aren't set. Run `gem push` to set them."
    end
  end

  desc 'Release packages to bintray'
  task :bintray => ['release:bintray:rpm',
                    'release:bintray:deb']

  namespace :bintray do
    task :ensure_token_set do
      raise "Please provide a BINTRAY_TOKEN" unless ENV['BINTRAY_TOKEN']
    end

    task :rpm => [:ensure_token_set] do
      upload_rpm_to_bintray("photish*.i386.rpm")
      upload_rpm_to_bintray("photish*.x86_64.rpm")
    end

    task :deb => [:ensure_token_set] do
      upload_deb_to_bintray("photish*_i386.deb", "i386")
      upload_deb_to_bintray("photish*_amd64.deb", "amd64")
    end
  end

  desc 'Release information to gtihub'
  task :github => ['release:github:tagged_release',
                   'release:github:upload_gem',
                   'release:github:upload_rpm',
                   'release:github:upload_deb',
                   'release:github:upload_build']

  namespace :github do
    task :ensure_token_set do
      raise "Please provide a GITHUB_TOKEN" unless ENV['GITHUB_TOKEN']
    end

    task :tagged_release => [:ensure_token_set] do
      puts create_github_release
    end

    task :upload_gem => [:ensure_token_set] do
      upload_file_to_github("RubyGem", "photish*.gem")
    end

    task :upload_rpm => [:ensure_token_set] do
      upload_file_to_github("RPM i386", "photish*.i386.rpm")
      upload_file_to_github("RPM x86_64", "photish*.x86_64.rpm")
    end

    task :upload_deb => [:ensure_token_set] do
      upload_file_to_github("DEB i386", "photish*_i386.deb")
      upload_file_to_github("DEB amd64", "photish*_amd64.deb")
    end

    task :upload_build => [:ensure_token_set] do
      upload_file_to_github("Linux x86", "photish*-x86.tar.gz")
      upload_file_to_github("Linux x86_64", "photish*-x86_64.tar.gz")
      upload_file_to_github("MacOSX", "photish*-osx.tar.gz")
      upload_file_to_github("Win32", "photish*-win32.zip")
    end
  end
end

def fuzzy_file(fuzzy_name)
  Dir.glob(fuzzy_name).max_by { |f| File.mtime(f) }
end

def create_github_release
  payload = {
    tag_name: "v#{Photish::VERSION}",
    target_commiish: "master",
    name: "#{Photish::NAME_AND_VERSION}",
    body: `git log -1 v#{Photish::VERSION} --pretty=%B`.strip
  }
  JSON.parse(`curl -sS -H "Content-Type: application/json" \
                   -u henrylawson:#{ENV['GITHUB_TOKEN']} \
                   --request POST \
                   --data '#{payload.to_json}' \
                   https://api.github.com/repos/henrylawson/photish/releases`)
end

def get_upload_url
  response = JSON.parse(`curl -sS \
                   -u henrylawson:#{ENV['GITHUB_TOKEN']} \
                   --request GET \
                   https://api.github.com/repos/henrylawson/photish/releases/tags/v#{Photish::VERSION}`)
  puts url = response.fetch('upload_url').gsub(/\{.*\}/, '')
  url
end

def upload_file_to_github(label, fuzzy_name)
  puts path = fuzzy_file("#{TaskConfig::BINARY_DIR}/#{fuzzy_name}")
  name = File.basename(path)
  puts JSON.parse(`curl -sS -H "Content-Type: application/octet-stream" \
             -u henrylawson:#{ENV['GITHUB_TOKEN']} \
             --request POST \
             --data-binary @"#{path}" \
             #{get_upload_url}?name=#{URI.escape(name)}&label=#{URI.escape(label)}`)

end

def upload_rpm_to_bintray(fuzzy_name)
  puts path = fuzzy_file("#{TaskConfig::BINARY_DIR}/#{fuzzy_name}")
  name = File.basename(path)
  puts JSON.parse(`curl -T #{path} \
                   -uhenrylawson:#{ENV['BINTRAY_TOKEN']} \
                   "https://api.bintray.com/content/henrylawson/rpm/photish/#{Photish::VERSION}/#{name}?publish=1&override=1"`)
end

def upload_deb_to_bintray(fuzzy_name, architecture)
  puts path = fuzzy_file("#{TaskConfig::BINARY_DIR}/#{fuzzy_name}")
  name = File.basename(path)
  puts JSON.parse(`curl -T #{path} \
                   -uhenrylawson:#{ENV['BINTRAY_TOKEN']} \
                   "https://api.bintray.com/content/henrylawson/deb/photish/#{Photish::VERSION}/#{name};deb_distribution=all;deb_component=main;deb_architecture=#{architecture}?publish=1&override=1"`)
end
