require 'colorize'

namespace :dev do
  desc 'Release a new version'
  task :bump do
    system("mvim -f lib/photish/version.rb") || abort('Error updating version'.red)
    system("git add lib/photish/version.rb") || abort('Error adding verison'.red)
    system("git commit") || abort("Error creating commit".red)
    system("git diff-index --quiet HEAD") || abort("Uncommited changes".red)
    system("rake helpers:git_push_tag") || abort("Creating tag failed".red)
  end

  desc 'Git push with tag'
  task :git_push_tag do
    begin
      sh "git tag -a -m \"Version #{Photish::VERSION}\" v#{Photish::VERSION}"
    rescue
      sh "git tag -d v#{Photish::VERSION}"
      raise
    end
  end
end
