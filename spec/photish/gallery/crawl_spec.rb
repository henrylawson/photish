require 'spec_helper'
require 'tmpdir'

describe Photish::Gallery::Crawl do
  before(:each) do
    @dir = Dir.mktmpdir('photish')
    setup_collection1
    setup_collection2
    setup_collection3
  end

  after(:each) do
    FileUtils.remove_entry_secure @dir
  end

  subject { Photish::Gallery::Crawl.new(@dir) }

  it 'crawls the collections' do
    expect(subject.load
                  .map(&:name)).to contain_exactly('collection1',
                                                   'collection2',
                                                   'collection3')
  end

  it 'loads all the photos in each collection' do
    expect(subject.load
                  .find { |c| c.name == 'collection1' } 
                  .photos
                  .map(&:name)).to contain_exactly('dog1',
                                                   'dog2')
    expect(subject.load
                  .find { |c| c.name == 'collection2' } 
                  .photos
                  .map(&:name)).to contain_exactly('dog3',
                                                   'dog4')
    expect(subject.load
                  .find { |c| c.name == 'collection3' } 
                  .photos
                  .map(&:name)).to contain_exactly('dog5',
                                                   'dog6',
                                                   'dog7')
  end

  def setup_collection1
    collection1 = File.join(@dir, 'collection1')
    FileUtils::mkdir_p(collection1)
    FileUtils::cp(fixture_file('dog1.jpg'), collection1)
    FileUtils::cp(fixture_file('dog2.jpg'), collection1)
  end

  def setup_collection2
    collection2 = File.join(@dir, 'collection2')
    FileUtils::mkdir_p(collection2)
    FileUtils::cp(fixture_file('dog3.jpg'), collection2)
    FileUtils::cp(fixture_file('dog4.jpg'), collection2)
  end

  def setup_collection3
    collection3 = File.join(@dir, 'collection3')
    FileUtils::mkdir_p(collection3)
    FileUtils::cp(fixture_file('dog5.jpg'), collection3)
    FileUtils::cp(fixture_file('dog6.jpg'), collection3)
    FileUtils::cp(fixture_file('dog7.jpg'), collection3)
  end
end
