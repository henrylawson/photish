require "bundler/gem_tasks"
require 'colorize'

desc 'Release a new version'
task :bump do
  system("mvim -f lib/photish/version.rb") || abort('Error updating version'.red)
  system("git add lib/photish/version.rb") || abort('Error adding verison'.red)
  system("git commit") || abort("Error creating commit".red)
  system("git diff-index --quiet HEAD") || abort("Uncommited changes".red)
  system("rake release:source_control_push") || abort("Creating tag failed".red)
end

desc 'Release information to gtihub'
task 'release:github' do
  raise "Please provide a GITHUB_TOKEN" unless ENV['GITHUB_TOKEN']
  payload = {
    tag_name: "v#{Photish::VERSION}",
    target_commiish: "master",
    name: "Photish v#{Photish::VERSION}",
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
