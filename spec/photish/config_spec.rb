require 'spec_helper'

describe Photish::Config do
  let(:config_file) do
    file = Tempfile.new('config_file')
    file.write <<TEXT
---
photo_dir: /config/photo_dir
output_dir: /config/output_dir
TEXT
    file.close
    file
  end

  subject do
    Photish::Config.new(config_file.path, {
      photo_dir: '/my/folder',
      key_not_in_file: 'override_val'
    })
  end

  context 'the key is defined in the config file' do
    context 'there is no override value' do
      it 'returns the config value' do
        expect(subject.val(:output_dir)).to eq('/config/output_dir')
      end
    end

    context 'there is an override value' do
      it 'returns the override value' do
        expect(subject.val(:photo_dir)).to eq('/my/folder')
      end
    end
  end

  context 'the key is not defined in the config file' do
    context 'there is no override value' do
      it 'returns nil' do
        expect(subject.val(:random_key)).to be_nil
      end
    end

    context 'there is an override value' do
      it 'returns the override value' do
        expect(subject.val(:key_not_in_file)).to eq('override_val')
      end
    end
  end
end
