Then(/^the config file should be created$/) do
  config_path = File.join(@working_directory, 'config.yml')
  expect(File.exists?(config_path)).to be_truthy
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
  @uri = URI.parse("http://localhost:9876/")
  Retriable.retriable(tries: 10, base_interval: 0.5, on: [RSpec::Expectations::ExpectationNotMetError, Errno::ECONNREFUSED]) do
    response = Net::HTTP.get_response(@uri)
    expect(response.kind_of?(Net::HTTPSuccess)).to be_truthy
  end
end

Then(/^all (.*) pages and images should be available$/) do |number|
  pages = []
  Anemone.crawl(@uri) do |anemone|
    anemone.on_every_page do |page|
      pages << page
    end
  end
  expect(pages.count).to eq(number.to_i)
  
  error_message = -> do
    failed_urls = pages.reject! { |p| p.code == 200 }
                        .map { |p| "=> #{p.code} | #{p.url}\n" }
                        .join
    "Got a non 200 for URLs:\n#{failed_urls}"
  end
  expect(pages.any? { |page| page.code != 200 }).to be_falsey, error_message
end

When(/^I add an album of photos$/) do
  FileUtils.cp_r(File.join(@working_directory, 'photos', 'Big Dogs'), 
                 File.join(@working_directory, 'photos', 'Big Dogs Copy'))
end

When(/^I remove an album of photos$/) do
  FileUtils.rm_rf(File.join(@working_directory, 'photos', 'Big Dogs Copy'))
end

When(/^I edit a template$/) do
  layout_file = File.join(@working_directory, 'site', '_templates', 'layout.slim')
  File.open(layout_file, 'a') do |f|
    f.puts "    | Added by feature test"
  end
end

Then(/^the album should appear$/) do
  Retriable.retriable(tries: 10, base_interval: 0.5, on: [RSpec::Expectations::ExpectationNotMetError, Errno::ECONNREFUSED]) do
    expect(open(@uri).read).to include('Big Dogs Copy')
  end
end

Then(/^the album should be gone$/) do
  count = 0
  Retriable.retriable(tries: 10, base_interval: 0.5, on: [RSpec::Expectations::ExpectationNotMetError, Errno::ECONNREFUSED]) do
    count = count + 1
    html_page = open(@uri).read
    expect(html_page).to_not include('Big Dogs Copy')
    expect(html_page).to include('Big Dogs')
    expect(html_page).to include('Small Dogs')
  end
end

Then(/^I should see the change appear in the template$/) do
  Retriable.retriable(tries: 10, base_interval: 0.5, on: [RSpec::Expectations::ExpectationNotMetError, Errno::ECONNREFUSED]) do
    expect(open(@uri).read).to include('Added by feature test')
  end
end

And(/^binding pry$/) do
  binding.pry
end
