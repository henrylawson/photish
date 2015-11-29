require 'spec_helper'

describe Photish::Gallery::Album do
  before(:each) do
    @dir = Dir.mktmpdir('photish')
    @album_dir = File.join(@dir, 'Rio de Janeiro')
    FileUtils.mkdir_p(@album_dir)
    FileUtils::cp(fixture_file('dog1.jpg'), @album_dir)
    FileUtils::cp(fixture_file('dog2.jpg'), @album_dir)
    FileUtils.mkdir_p(File.join(@album_dir, 'Day 1'))
    FileUtils.mkdir_p(File.join(@album_dir, 'Day 2'))
    FileUtils.mkdir_p(File.join(@album_dir, 'Day 3'))
  end

  after(:each) do
    FileUtils.remove_entry_secure @dir
  end

  subject { Photish::Gallery::Album.new(AlbumParent.new, @album_dir) }

  context '#photos' do
    it 'loads all the photos in each album' do
      expect(subject.photos
                    .map(&:name)).to contain_exactly('dog1',
                                                     'dog2')
    end
  end

  context '#albums' do
    it 'loads all the albums inside this album' do
      expect(subject.albums
                    .map(&:name)).to contain_exactly('Day 1',
                                                     'Day 2',
                                                     'Day 3')
      expect(subject.albums
                    .map(&:url)).to contain_exactly('/rio-de-janeiro/day-1/index.html',
                                                    '/rio-de-janeiro/day-2/index.html',
                                                    '/rio-de-janeiro/day-3/index.html')
    end
  end

  context '#url' do
    it 'is the snake version of the name with html file' do
      expect(subject.url).to eq('/rio-de-janeiro/index.html')
    end
  end

  context '#url_parts' do
    it 'is the snake version of the name with html file' do
      expect(subject.url_parts).to eq(['rio-de-janeiro', 'index.html'])
    end
  end

  context '#base_url_parts' do
    it 'is the snake version of the name' do
      expect(subject.base_url_parts).to eq(['rio-de-janeiro'])
    end
  end

  context '#name' do
    it 'is the raw folder name' do
      expect(subject.name).to eq('Rio de Janeiro')
    end
  end

  context '#metadata' do
    context 'when a YAML file is present' do
      it 'has all the data loaded' do
        metadata_file = File.join(@album_dir + '.yml')
        FileUtils.cp(fixture_file('metadata.yml'), metadata_file)

        expect(subject.metadata.description).to eq('Description')
        expect(subject.metadata.notes).to eq(['Note 1', 'Note 2'])
        expect(subject.metadata.category.title).to eq('Title')
        expect(subject.metadata.category.blurb).to eq('Blurb')
      end
    end

    context 'when no YAML file is present' do
      it 'returns nil' do
        expect(subject.metadata).to eq(nil)
      end
    end
  end

  context '#breadcrumbs' do
    it 'returns a single unordered list with the album' do
      expect(subject.breadcrumbs).to have_tag('ul', with: { class: 'breadcrumbs' }) do
        with_tag 'li', with: { class: 'breadcrumb crumb-0 crumb-first' }
        with_tag 'li', with: { class: 'breadcrumb crumb-1 crumb-last' }
      end
    end

    it 'has the correct deails for this crumb' do
      expect(subject.breadcrumbs).to have_tag('li', with: { class: 'crumb-1' }) do
        with_tag 'a', with: { href: subject.url }, text: subject.name
      end
    end
  end

  context 'allows for plugins' do
    it 'responds to plugin method' do
      expect(subject.hello).to eq('yes')
    end
  end
end

module Photish::Plugin::MyAlbumPlugin
  def self.is_for?(type)
    Photish::Plugin::Type::Album == type
  end

  def hello
    'yes'
  end
end

class AlbumParent
  def base_url_parts
    []
  end

  def name
    'Home'
  end

  def url
    '/'
  end

  def url_info
    OpenStruct.new(host: '/')
  end

  def parents_and_me
    [self]
  end
end
