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
    payload = {
      tag_name: "v#{Photish::VERSION}",
      target_commiish: "master",
      name: "#{Photish::NAME_AND_VERSION}",
      body: `git log -1 --pretty=%B`.strip
    }
    puts response = JSON.parse(`curl -sS -H "Content-Type: application/json" \
                     -u henrylawson:#{ENV['GITHUB_TOKEN']} \
                     --request POST \
                     --data '#{payload.to_json}' \
                     https://api.github.com/repos/henrylawson/photish/releases`)

    puts upload_url = response['upload_url'].gsub(/\{.*\}/, '')
    [{ path: "pkg/photish-#{Photish::VERSION}.gem",
       name: "photish-#{Photish::VERSION}.gem",
       label: 'Ruby Gem' }].each do |file|
         puts JSON.parse(`curl -sS -H "Content-Type: application/octet-stream" \
                     -u henrylawson:#{ENV['GITHUB_TOKEN']} \
                     --request POST \
                     --data-binary @"#{file[:path]}" \
                     #{upload_url}?name=#{URI.escape(file[:name])}&label=#{URI.escape(file[:label])}`)
    end
  end
end
