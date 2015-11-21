Given(/^a config file$/) do
  path = File.join(@working_directory, 'config.yml')
  File.open(path, "w") do |f|
    f.puts '---'
    f.puts 'val: lol'
  end
end

Given(/^a photo directory$/) do
  path = File.join(@working_directory, 'photos')
  FileUtils.cp_r(fixture_file('photos'), path)
end

Given(/^a site directory with templates$/) do
  path = File.join(@working_directory, 'site')
  FileUtils.cp_r(fixture_file('site'), path)
end

