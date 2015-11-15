require 'spec_helper'

describe Photish::Config::FileConfig do
  context '#hash' do
    let(:config_file) do
      file = Tempfile.new('config_file')
      file.write <<TEXT
---
photo_dir: /config/photo_dir
site_dir: /config/site_dir
TEXT
      file.close
      file
    end

    subject { Photish::Config::FileConfig.new(config_file.path) }

    it 'loads the file as a hash' do
      expect(subject.hash).to include('photo_dir' => '/config/photo_dir',
                                      'site_dir' => '/config/site_dir')
    end
  end
end
