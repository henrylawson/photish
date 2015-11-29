require 'spec_helper'

describe Photish::Log::Logger do
  subject { Photish::Log::Logger.instance }
  
  let(:config) { RecursiveOpenStruct.new(config_hash) }

  after do
    Logging.logger.root.clear_appenders
    subject.setup_complete = false
  end

  context 'all settings enabled' do
    let(:config_hash) do
      {
          logging: {
            colorize: true,
            output: ['stdout', 'file'],
            level: 'info'
          }
      }
    end

    it 'enables colors' do
      expect(Logging).to receive(:color_scheme)

      subject.setup_logging(config)
    end

    it 'enables output to STDOUT' do
      subject.setup_logging(config)

      expect(Logging.logger.root.appenders.map(&:name)).to include('stdout')
    end

    it 'enables output to file' do
      subject.setup_logging(config)

      expect(Logging.logger.root.appenders.map(&:name)).to include('log/photish.log')
    end
  end
  
  context 'all settings disabled' do
    let(:config_hash) do
      {
          logging: {
            colorize: false,
            output: [],
            level: 'info'
          }
      }
    end

    it 'no colors' do
      expect(Logging).to_not receive(:color_scheme)

      subject.setup_logging(config)
    end

    it 'no output to STDOUT' do
      subject.setup_logging(config)

      expect(Logging.logger.root.appenders.map(&:name)).to_not include('stdout')
    end

    it 'no output to file' do
      subject.setup_logging(config)

      expect(Logging.logger.root.appenders.map(&:name)).to_not include('log/photish.log')
    end
  end
end
