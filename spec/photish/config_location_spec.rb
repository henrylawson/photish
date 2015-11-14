require 'spec_helper'

describe Photish::ConfigLocation do
  context '#path' do
    subject { Photish::ConfigLocation.new(site_dir) }

    context 'file exists' do
      before(:each) do
        FileUtils.mkdir_p(site_dir) if site_dir
        FileUtils.touch(location)
      end

      after(:each) do
        FileUtils.rm_rf(location)
      end

      context 'no site directory provided' do
        let(:site_dir) { nil }
        let(:location) { File.join(Dir.pwd, Photish::ConfigLocation::FILE_NAME) }

        it 'config file is in current working directory' do
          expect(subject.path).to eq(location)
        end
      end

      context 'site directory provided' do
        let(:site_dir) { '/tmp/site_dir' }
        let(:location) { File.join(site_dir, Photish::ConfigLocation::FILE_NAME) }
        
        it 'config is in the site directory' do
          expect(subject.path).to eq(location)
        end
      end
    end

    context 'file does not exist' do
      let(:site_dir) { nil }
      
      it 'raises error' do
        expect { subject.path }.to raise_error(/does not exist/)
      end
    end
  end
end
