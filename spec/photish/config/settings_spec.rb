require 'spec_helper'

describe Photish::Config::Settings do
  let(:config) do
    {
      setting_1: 'value1',
      setting_2: 'value2',
      'setting_3' => nil,
      'setting_4' => 'value3'
    }
  end

  context '#val' do

    subject { Photish::Config::Settings.new(config) }

    context 'the key is not defined' do
      it 'returns nil' do
        expect(subject.val(:random_key)).to be_nil
      end
    end

    context 'the key is defined but value is nil' do
      it 'returns nil' do
        expect(subject.val(:setting_3)).to be_nil
      end
    end

    context 'the key is defined' do
      it 'returns the value' do
        expect(subject.val(:setting_1)).to eq('value1')
        expect(subject.val(:setting_2)).to eq('value2')
      end
    end

    context 'the key is converted to a symbol' do
      it 'returns the value' do
        expect(subject.val(:setting_4)).to eq('value3')
      end
    end
  end

  context '#override' do
    let(:override_config) do
      {
        setting_1: 'value_override1',
        'setting_2' => nil,
        'setting_5' => 'value_override2'
      }
    end

    subject do
      new_subject = Photish::Config::Settings.new(config)
      new_subject.override(override_config)
    end

    it 'replaces any matched keys' do
      expect(subject.val(:setting_1)).to eq('value_override1')
    end

    it 'ignores overrides with nil values' do
      expect(subject.val(:setting_2)).to eq('value2')
    end

    it 'leaves values not in override as is' do
      expect(subject.val(:setting_4)).to eq('value3')
    end

    it 'adds any new keys' do
      expect(subject.val(:setting_5)).to eq('value_override2')
    end
  end
end
