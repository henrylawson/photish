require 'spec_helper'

describe Photish::Rake::Task do
  it 'defines the task and calls the command' do
    Photish::Rake::Task.new(:generate, 'some description') do |t|
      t.options = 'generate'
    end

    expect_any_instance_of(Photish::Command::Generate).to receive(:execute)

    Rake::Task['generate'].invoke
  end
end
