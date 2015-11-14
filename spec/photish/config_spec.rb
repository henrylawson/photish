require 'spec_helper'

describe Photish::Config do
  context '#val' do
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

    subject { Photish::Config.new(config_file.path) }

    before do
      subject.override!({
        photo_dir: '/my/folder',
        key_not_in_file: 'override_val',
        site_dir: nil,
        site_name: 'Hello World'
      })
    end

    context 'the key is defined in the config file' do
      context 'there is no override value' do
        it 'returns the config value' do
          expect(subject.val(:site_name)).to eq('Hello World')
        end
      end

      context 'there is an override value' do
        it 'returns the override value' do
          expect(subject.val(:photo_dir)).to eq('/my/folder')
        end
      end

      context 'there is an override value but it is nil' do
        it 'returns the config value' do
          expect(subject.val(:site_dir)).to eq('/config/site_dir')
        end
      end
    end

    context 'the key is not defined in the config file' do
      context 'there is no default value' do
        it 'returns nil' do
          expect(subject.val(:random_key)).to be_nil
        end
      end

      context 'there is no override value' do
        it 'returns the default value' do
          expect(subject.val(:output_dir)).to eq(File.join(Dir.pwd, 'output'))
        end
      end

      context 'there is an override value' do
        it 'returns the override value' do
          expect(subject.val(:key_not_in_file)).to eq('override_val')
        end
      end
    end
  end
end
