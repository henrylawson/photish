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
  Retriable.retriable(RETRY_OPTIONS) do
    response = Net::HTTP.get_response(@uri)
    expect(response.kind_of?(Net::HTTPSuccess)).to be_truthy
  end
end

Then(/^all (.*) pages and images should be available$/) do |number|
  Retriable.retriable(RETRY_OPTIONS) do
    pages = []
    Anemone.crawl(@uri) do |anemone|
      anemone.on_every_page do |page|
        pages << page
      end
    end
    expect(pages.count).to eq(number.to_i), "Found pages #{pages.map(&:url).join("\n")}"

    error_message = -> do
      failed_urls = pages.reject! { |p| p.code == 200 }
                          .map { |p| "=> #{p.code} | #{p.url}\n" }
                          .join
      "Got a non 200 for URLs:\n#{failed_urls}"
    end
    expect(pages.any? { |page| page.code != 200 }).to be_falsey, error_message
  end
end

And(/^the welcome page should appear$/) do
  Retriable.retriable(RETRY_OPTIONS) do
    expect(open(@uri).read).to include('Welcome')
  end
end

When(/^I add an album of photos$/) do
  FileUtils.cp_r(File.join(@working_directory, 'photos', 'Big Dogs'),
                 File.join(@working_directory, 'photos', 'Big Dogs Copy'))
end

When(/^I remove an album of photos$/) do
  FileUtils.rm_rf(File.join(@working_directory, 'photos', 'Big Dogs Copy'))
end

When(/^I edit a template$/) do
  layout_file = File.join(@working_directory,
                          'site',
                          '_templates',
                          'layout.slim')
  File.open(layout_file, 'a') do |f|
    f.puts "    | Added by feature test"
  end
end

Then(/^the album should appear$/) do
  @new_album_file = File.join(@working_directory,
                              'output',
                              'big-dogs-copy',
                              'index.html')
  Retriable.retriable(RETRY_OPTIONS) do
    expect(open(@uri).read).to include('Big Dogs Copy')
    expect(File.exist?(@new_album_file)).to be_truthy,
      "File does not exist #{@new_album_file}, it should exist as album created"
  end
end

Then(/^the album should be gone$/) do
  Retriable.retriable(RETRY_OPTIONS) do
    html_page = open(@uri).read
    expect(html_page).to_not include('Big Dogs Copy')
    expect(html_page).to include('Big Dogs')
    expect(html_page).to include('Small Dogs')
  end
end

When(/^I change the config to use workers, threads and a plugin Gem$/) do
  change_config do |config|
    config['workers'] = 2
    config['threads'] = 1
    config['plugins'] = ['photish/plugin/sshdeploy']
  end
end

When(/^I change the config and a file in the site dir$/) do
  change_config do |config|
    config['qualities'][2] = { 
      'name' => 'features', 
      'params' => ['-resize', '300x300'] 
    }
  end
end

Then(/^the config changes should reflect$/) do
  new_image_file = File.join(@working_directory,
                             'output',
                             'big-dogs',
                             'tired-dogs',
                             'images',
                             'tired-dogs-features.jpg')
  Retriable.retriable(RETRY_OPTIONS) do
    expect(File.exist?(new_image_file)).to be_truthy,
      "Expected the new image file #{new_image_file} to be created"
  end
end

Then(/^the album generated files should be gone$/) do
  Retriable.retriable(RETRY_OPTIONS) do
    expect(File.exist?(@new_album_file)).to be_falsey,
      "File exists #{@new_album_file}, it should be deleted as album gone"
  end
end

Then(/^the change should appear in the template$/) do
  Retriable.retriable(RETRY_OPTIONS) do
    expect(open(@uri).read).to include('Added by feature test')
  end
end

And(/^binding pry$/) do
  binding.pry
end
