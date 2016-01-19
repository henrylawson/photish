desc 'Release to all repositories'
task :release => ['release:rubygems',
                  'release:github']

namespace :release do
  desc 'Release to RubyGems'
  task :rubygems do
    if Pathname.new("~/.gem/credentials").expand_path.exist?
      allowed_push_host = nil
      sh "gem push 'pkg/photish-#{Photish::VERSION}.gem'"
    else
      raise "Your rubygems.org credentials aren't set. Run `gem push` to set them."
    end
  end

  desc 'Release information to gtihub'
  task :github do
    raise "Please provide a GITHUB_TOKEN" unless ENV['GITHUB_TOKEN']

    puts response = create_github_release
    puts upload_url = response['upload_url'].gsub(/\{.*\}/, '')

    upload_file_to_github(upload_url, "RubyGem", "photish*.gem")

    upload_file_to_github(upload_url, "RPM i386", "photish*.i386.rpm")
    upload_file_to_github(upload_url, "RPM x86_64", "photish*.x86_64.rpm")

    upload_file_to_github(upload_url, "DEB i386", "photish*.i386.deb")
    upload_file_to_github(upload_url, "DEB amd64", "photish*.amd64.deb")

    upload_file_to_github(upload_url, "Linux x86", "photish*-x86.tar.gz")
    upload_file_to_github(upload_url, "Linux x86_64", "photish*-x86_64.tar.gz")
    upload_file_to_github(upload_url, "MacOSX", "photish*-osx.tar.gz")
    upload_file_to_github(upload_url, "Win32", "photish*-win32.tar.gz")
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

def upload_file_to_github(upload_url, label, fuzzy_name)
  puts path = fuzzy_file("pkg/#{fuzzy_name}")
  name = File.basename(path)
  puts JSON.parse(`curl -sS -H "Content-Type: application/octet-stream" \
             -u henrylawson:#{ENV['GITHUB_TOKEN']} \
             --request POST \
             --data-binary @"#{path}" \
             #{upload_url}?name=#{URI.escape(name)}&label=#{URI.escape(label)}`)

end
