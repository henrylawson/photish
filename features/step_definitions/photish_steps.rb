Given(/^a config file$/) do
  path = File.join(@working_directory)
  @config = YAML.load_file(fixture_file('config.yml'))
  FileUtils.cp_r(fixture_file('config.yml'), path)
end

Given(/^a photo directory$/) do
  path = File.join(@working_directory, 'photos')
  FileUtils.cp_r(fixture_file('photos'), path)
end

Given(/^a site directory$/) do
  path = File.join(@working_directory, 'site')
  FileUtils.cp_r(fixture_file('site'), path)
end

Then(/^the site should be available via HTTP$/) do
  @uri = URI.parse("http://localhost:#{@config['port']}/")
  Retriable.retriable(tries: 3, base_interval: 0.5) do
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
  error_message = ->{ "Got a non 200 for URLs:#{@pages.map(&:url).map { |u| "\n=> #{u}" }.join}" }
  expect(@pages.any? { |page| page.code != 200 }).to be_falsey, error_message
end


And(/^binding pry$/) do
  binding.pry
end
