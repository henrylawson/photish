require 'spec_helper'
require 'tmpdir'

describe Photish::Gallery::Collection do
  before(:each) do
    @dir = Dir.mktmpdir('photish')
    setup_album1
    setup_album2
    setup_album3
    copy_text_file_to_root
  end

  after(:each) do
    FileUtils.remove_entry_secure @dir
  end

  subject { Photish::Gallery::Collection.new(@dir) }

  it 'crawls the albums' do
    expect(subject.albums
                  .map(&:name)).to contain_exactly('album1',
                                                   'album2',
                                                   'album3')
  end

  it 'loads all the photos in each album' do
    expect(subject.albums
                  .find { |c| c.name == 'album1' } 
                  .photos
                  .map(&:name)).to contain_exactly('dog1',
                                                   'dog2')
    expect(subject.albums
                  .find { |c| c.name == 'album2' } 
                  .photos
                  .map(&:name)).to contain_exactly('dog3',
                                                   'dog4')
    expect(subject.albums
                  .find { |c| c.name == 'album3' } 
                  .photos
                  .map(&:name)).to contain_exactly('dog5',
                                                   'dog6',
                                                   'dog7')
  end
  
  def copy_text_file_to_root
    FileUtils::cp(fixture_file('text.txt'), @dir)
  end

  def setup_album1
    album1 = File.join(@dir, 'album1')
    FileUtils::mkdir_p(album1)
    FileUtils::cp(fixture_file('dog1.jpg'), album1)
    FileUtils::cp(fixture_file('dog2.jpg'), album1)
  end

  def setup_album2
    album2 = File.join(@dir, 'album2')
    FileUtils::mkdir_p(album2)
    FileUtils::cp(fixture_file('dog3.jpg'), album2)
    FileUtils::cp(fixture_file('dog4.jpg'), album2)
  end

  def setup_album3
    album3 = File.join(@dir, 'album3')
    FileUtils::mkdir_p(album3)
    FileUtils::cp(fixture_file('dog5.jpg'), album3)
    FileUtils::cp(fixture_file('dog6.jpg'), album3)
    FileUtils::cp(fixture_file('dog7.jpg'), album3)
  end
end
