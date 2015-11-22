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
    it 'is the raw file name' do
      expect(subject.name).to eq('Cute Dog')
    end
  end

  context '#images' do
    it 'has an image for each quality' do
      expect(subject.images
                    .map(&:quality_name)).to contain_exactly('High',
                                                             'Medium',
                                                             'Low')
    end
  end
end

class PhotoParent
  def base_url_parts
    ['pets']
  end

  def qualities
    [
      OpenStruct.new(name: 'High',   params: ['-resize', '800x600']),
      OpenStruct.new(name: 'Medium', params: ['-resize', '500x500']),
      OpenStruct.new(name: 'Low',    params: ['-resize', '200x200'])
    ]
  end
end