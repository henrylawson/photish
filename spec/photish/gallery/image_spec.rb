require 'spec_helper'

describe Photish::Gallery::Image do
  before(:each) do
    @dir = Dir.mktmpdir('photish')
    @image_path = File.join(@dir, 'Cute Dog.jpg')
    FileUtils.cp(fixture_file('dog1.jpg'), @image_path)
  end

  after(:each) do
    FileUtils.remove_entry_secure @dir
  end

  let(:quality) { OpenStruct.new(name: 'High', params: ['-resize', '500x500']) }

  subject { Photish::Gallery::Image.new(ImageParent.new, @image_path, quality) }

  context '#url' do
    it 'is the snake version of the name with html file' do
      expect(subject.url).to eq('/pets/cute-dog/images/cute-dog-high.jpg')
    end
  end

  context '#url_parts' do
    it 'is the snake version of the name with html file' do
      expect(subject.url_parts).to eq(['pets', 'cute-dog', 'images', 'cute-dog-high.jpg'])
    end
  end

  context '#base_url_parts' do
    it 'is the snake version of the name' do
      expect(subject.base_url_parts).to eq(['pets', 'cute-dog', 'images'])
    end
  end

  context '#name' do
    it 'is the raw file name' do
      expect(subject.name).to eq('Cute Dog High')
    end
  end
end

class ImageParent
  def base_url_parts
    ['pets', 'cute-dog']
  end
end
