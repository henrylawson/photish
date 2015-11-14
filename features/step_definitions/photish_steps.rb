Given(/^a config file at "([^"]*)"$/) do |config_file_directory|
  FileUtils.mkdir_p(config_file_directory)
  path = File.join(config_file_directory, 'config.yml')
  File.write(path, "---\nval: lol")
end

