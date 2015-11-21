Given(/^a config file$/) do
  @port = 9867
  path = File.join(@working_directory, 'config.yml')
  File.open(path, "w") do |f|
    f.puts '---'
    f.puts "port: #{@port}"
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

Then(/^the site should be available via HTTP$/) do
  @uri = URI.parse("http://localhost:#{@port}/")
  Retriable.retriable(tries: 3, base_interval: 0.5) do
    response = Net::HTTP.get_response(@uri)
    expect(response.kind_of?(Net::HTTPSuccess)).to be_truthy
  end
end

Then(/^not contain any dead links$/) do
  Anemone.crawl(@uri) do |anemone|
    anemone.on_every_page do |page|
      expect(page.code).to eq(200), "Expected 200, got #{page.code} for URL #{page.url}"
    end
  end
end
