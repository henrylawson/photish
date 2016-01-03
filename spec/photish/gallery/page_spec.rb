require 'spec_helper'

describe Photish::Gallery::Page do
  before(:each) do
    @dir = Dir.mktmpdir('photish')
    @page_path = File.join(@dir, 'Page 1.slim')
    FileUtils.cp(fixture_file('page1.slim'), @page_path)
  end

  after(:each) do
    FileUtils.remove_entry_secure @dir
  end

  subject { Photish::Gallery::Page.new(PageParent.new, @page_path) }

  context '#url' do
    it 'is the snake version of the name with html file' do
      expect(subject.url).to eq('/pets/page-1/index.html')
    end
  end

  context '#url_parts' do
    it 'is the snake version of the name with html file' do
      expect(subject.url_parts).to eq(['pets', 'page-1', 'index.html'])
    end
  end

  context '#base_url_parts' do
    it 'is the snake version of the name' do
      expect(subject.base_url_parts).to eq(['pets', 'page-1'])
    end
  end

  context '#name' do
    it 'is the raw file name' do
      expect(subject.name).to eq('Page 1')
    end
  end

  context '#metadata' do
    context 'when a YAML file is present' do
      it 'has all the data loaded' do
        metadata_file = File.join(@dir, 'Page 1.yml')
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
        with_tag 'li', with: { class: 'breadcrumb crumb-1' }
        with_tag 'li', with: { class: 'breadcrumb crumb-2 crumb-last' }
      end
    end

    it 'has the correct deails for this crumb' do
      expect(subject.breadcrumbs).to have_tag('li', with: { class: 'crumb-2' }) do
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

module Photish::Plugin::MyPagePlugin
  def self.is_for?(type)
    Photish::Plugin::Type::Page == type
  end

  def hello
    'yes'
  end
end

class PageParent
  def base_url_parts
    ['pets']
  end

  def name
    'Pets'
  end

  def url
    '/pets'
  end

  def url_info
    OpenStruct.new(host: '')
  end

  def parents_and_me
    [PageParentParent.new, self]
  end
end

class PageParentParent
  def name
    'Page Parent Parent'
  end

  def url
    '/page-parent-parent'
  end
end
