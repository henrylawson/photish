require 'spec_helper'

class TestMixin
  include Photish::Log::Logger
end

describe Photish::Log do

  subject { TestMixin.new }

  it 'writes the message to standard out' do
    expect { subject.log("hello") }.to output(/hello\n/).to_stdout
  end

  it 'records the time the message was written' do
    timestamp = Time.now.iso8601
    expect { subject.log("hello") }.to output(/#{Regexp.escape(timestamp)}/).to_stdout
  end
end
