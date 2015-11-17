require 'spec_helper'

describe Photish::Gallery::Photo do
  before(:each) do
    @dir = Dir.mktmpdir('photish')
    @photo_path = File.join(@dir, 'Cute Dog.jpg')
    FileUtils.cp(fixture_file('dog1.jpg'), @photo_path)
  end

  after(:each) do
    FileUtils.remove_entry_secure @dir
  end

  subject { Photish::Gallery::Photo.new(PhotoParent.new, @photo_path) }

  context '#url' do
    it 'is the snake version of the name with html file' do
      expect(subject.url).to eq('/pets/cute-dog/index.html')
    end
  end

  context '#url_parts' do
    it 'is the snake version of the name with html file' do
      expect(subject.url_parts).to eq(['pets', 'cute-dog', 'index.html'])
    end
  end

  context '#base_url_parts' do
    it 'is the snake version of the name' do
      expect(subject.base_url_parts).to eq(['pets', 'cute-dog'])
    end
  end

  context '#name' do
    it 'is the raw folder name' do
      expect(subject.name).to eq('Cute Dog')
    end
  end
end

class PhotoParent
  def base_url_parts
    ['pets']
  end
end
