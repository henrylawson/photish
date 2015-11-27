Then(/^the config file should be created$/) do
  config_path = File.join(@working_directory, 'config.yml')
  expect(File.exists?(config_path)).to be_truthy
  @config = YAML.load_file(config_path)
end

Then(/^a photos directory should be created$/) do
  path = File.join(@working_directory, 'photos')
  expect(Dir.exists?(path)).to be_truthy
end

Then(/^a site directory should be created$/) do
  path = File.join(@working_directory, 'site')
  expect(Dir.exists?(path)).to be_truthy
end

Then(/^the site should be available via HTTP$/) do
  @uri = URI.parse("http://localhost:#{@config['port']}/")
  Retriable.retriable(tries: 10, base_interval: 0.5) do
    response = Net::HTTP.get_response(@uri)
    expect(response.kind_of?(Net::HTTPSuccess)).to be_truthy
  end
end

Then(/^all (.*) pages and images should be available$/) do |number|
  @pages = []
  Anemone.crawl(@uri) do |anemone|
    anemone.on_every_page do |page|
      @pages << page
    end
  end
  expect(@pages.count).to eq(number.to_i)
end

Then(/^not contain any dead links$/) do
  error_message = -> do
    failed_urls = @pages.reject! { |p| p.code == 200 }
                        .map { |p| "=> #{p.code} | #{p.url}\n" }
                        .join
    "Got a non 200 for URLs:\n#{failed_urls}"
  end
  expect(@pages.any? { |page| page.code != 200 }).to be_falsey, error_message
end

And(/^binding pry$/) do
  binding.pry
end
