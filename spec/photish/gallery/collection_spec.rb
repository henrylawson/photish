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

  let(:url_host) { nil }
  let(:url_base) { nil }
  let(:url_type) { 'absolute_relative' }
  let(:config) do
    RecursiveOpenStruct.new({
      photo_dir: @dir,
      qualities: [{ name: 'low' }],
      url: {
        host: url_host,
        base: url_base,
        type: url_type,
      },
      image_extensions: ['jpg'],
      page_extension: 'slim',
    })
  end

  subject { Photish::Gallery::Collection.new(config) }

  context '#albums' do
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
  end

  context '#all_photos' do
    it 'loads all photos in all albums' do
      expect(subject.all_photos
                    .map(&:name)).to contain_exactly('dog1',
                                                     'dog2',
                                                     'dog3',
                                                     'dog4',
                                                     'dog5',
                                                     'dog6',
                                                     'dog7')
    end
  end

  context '#all_pages' do
    it 'loads all pages in all albums' do
      expect(subject.all_pages.map(&:name)).to contain_exactly('page1',
                                                               'page2')
    end
  end

  context '#all_images' do
    it 'loads all images in all photos in all albums' do
      expect(subject.all_images
                    .map(&:name)).to contain_exactly('dog1 low',
                                                     'dog2 low',
                                                     'dog3 low',
                                                     'dog4 low',
                                                     'dog5 low',
                                                     'dog6 low',
                                                     'dog7 low')
    end
  end

  context '#url, #url_parts, #base_url_parts' do
    context 'no URL config provided' do
      it 'is the index at the root' do
        expect(subject.url).to eq('/index.html')
        expect(subject.url_path).to eq('index.html')
        expect(subject.url_parts).to eq(['index.html'])
        expect(subject.base_url_parts).to eq([])
      end
    end

    context 'host is provieded' do
      let(:url_host) { 'https://mysite.com' }

      it 'url is the index at the root without host' do
        expect(subject.url).to eq('/index.html')
        expect(subject.url_path).to eq('index.html')
        expect(subject.url_parts).to eq(['index.html'])
        expect(subject.base_url_parts).to eq([])
      end

      context 'type is absolute_uri' do
        let(:url_type) { 'absolute_uri' }

        it 'url is the index at the root without host' do
          expect(subject.url).to eq('https://mysite.com/index.html')
          expect(subject.url_path).to eq('index.html')
          expect(subject.url_parts).to eq(['index.html'])
          expect(subject.base_url_parts).to eq([])
        end
      end
    end

    context 'base is provided' do
      let(:url_base) { 'subdir' }

      it 'is the index within the base' do
        expect(subject.url).to eq('/subdir/index.html')
        expect(subject.url_path).to eq('subdir/index.html')
        expect(subject.url_parts).to eq(['subdir', 'index.html'])
        expect(subject.base_url_parts).to eq(['subdir'])
      end
    end

    context 'base and host are provided' do
      let(:url_host) { 'https://mysite.com' }
      let(:url_base) { 'subdir' }

      it 'is the index within the base' do
        expect(subject.url).to eq('/subdir/index.html')
        expect(subject.url_path).to eq('subdir/index.html')
        expect(subject.url_parts).to eq(['subdir', 'index.html'])
        expect(subject.base_url_parts).to eq(['subdir'])
      end

      context 'type is absolute_uri' do
        let(:url_type) { 'absolute_uri' }

        it 'is the index within the base and host' do
          expect(subject.url).to eq('https://mysite.com/subdir/index.html')
          expect(subject.url_path).to eq('subdir/index.html')
          expect(subject.url_parts).to eq(['subdir', 'index.html'])
          expect(subject.base_url_parts).to eq(['subdir'])
        end
      end
    end
  end

  context '#metadata' do
    context 'when a YAML file is present' do
      it 'has all the data loaded' do
        metadata_file = File.join(@dir + '.yml')
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
    it 'returns a single unordered list with the collection' do
      expect(subject.breadcrumbs).to have_tag('ul', with: { class: 'breadcrumbs' }) do
        with_tag 'li', with: { class: 'breadcrumb crumb-0 crumb-first crumb-last crumb-only' }
      end
    end

    it 'has the correct details for this crumb' do
      expect(subject.breadcrumbs).to have_tag('li', with: { class: 'crumb-0' }) do
        with_tag 'a', with: { href: subject.url }, text: subject.name
      end
    end
  end

  def copy_text_file_to_root
    FileUtils::cp(fixture_file('text.txt'), @dir)
  end

  def setup_album1
    album1 = File.join(@dir, 'album1')
    FileUtils::mkdir_p(album1)
    FileUtils::cp(fixture_file('dog1.jpg'), album1)
    FileUtils::cp(fixture_file('dog2.jpg'), album1)
    FileUtils::cp(fixture_file('page1.slim'), album1)
  end

  def setup_album2
    album2 = File.join(@dir, 'album2')
    FileUtils::mkdir_p(album2)
    FileUtils::cp(fixture_file('dog3.jpg'), album2)
    FileUtils::cp(fixture_file('dog4.jpg'), album2)
    FileUtils::cp(fixture_file('page2.slim'), album2)
  end

  def setup_album3
    album3 = File.join(@dir, 'album3')
    FileUtils::mkdir_p(album3)
    FileUtils::cp(fixture_file('dog5.jpg'), album3)
    FileUtils::cp(fixture_file('dog6.jpg'), album3)
    FileUtils::cp(fixture_file('dog7.jpg'), album3)
  end

  context 'allows for plugins' do
    it 'responds to plugin method' do
      expect(subject.hello).to eq('yes')
    end
  end
end

module Photish::Plugin::MyCollectionPlugin
  def self.is_for?(type)
    Photish::Plugin::Type::Collection == type
  end

  def hello
    'yes'
  end
end
