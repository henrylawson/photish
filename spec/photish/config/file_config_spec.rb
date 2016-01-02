require 'spec_helper'

describe Photish::Config::FileConfig do
  context '#hash' do
    let(:temp_dir) { Dir.mktmpdir }
    let(:config_file)  { File.join(temp_dir, 'config.yml') }

    before do
      File.open(config_file, 'w') do |f|
        f.write <<TEXT
---
photo_dir: /config/photo_dir
site_dir: /config/site_dir
TEXT
      end
    end

    subject { Photish::Config::FileConfig.new(temp_dir) }

    it 'loads the file as a hash' do
      expect(subject.hash).to include('photo_dir' => '/config/photo_dir',
                                      'site_dir' => '/config/site_dir')
    end
  end
end
