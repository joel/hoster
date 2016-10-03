require 'spec_helper'

shared_examples 'success' do
  specify { expect(subject.status).to eq(200) }
end

shared_context 'should have public message' do |message|
  before do
    expect_any_instance_of(Slack::Poster).to receive(:send_message).with(message)
  end
end

shared_examples 'should have private message' do |message|
  specify { expect(subject.body).to eql(message) }
end

describe HostApp, type: :controller do

  describe 'bad arguments' do
    subject { get '/?text=unknow' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', "unknow action => 'unknow'\n\nHELP:\n/#{ENV['COMMAND']} help -  give this hepd message\n/#{ENV['COMMAND']} get - give you the next chair, (dry does no affect anything)\n/#{ENV['COMMAND']} get dry - give you the next chair, (dry does no affect anything)\n/#{ENV['COMMAND']} who - give you the current chair\n/#{ENV['COMMAND']} list - give the enterely list of recorded people\n/#{ENV['COMMAND']} reset - removing all blacklisted people\n/#{ENV['COMMAND']} left - who could be the chair\n/#{ENV['COMMAND']} add - put a person to the blacklist\n/#{ENV['COMMAND']} add <T_1_WEEK = 604800, T_2_WEEKS = 1209600, T_3_WEEKS = 1814400> - indicate how long a person should stay on the blacklist\n/#{ENV['COMMAND']} blacklist - get blacklisted people with remain time\n"
  end

  describe 'action ::list::' do
    subject { get '/?text=list' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', 'List :: Alexandra, Joel, Krzysztof, Lukasz, Steve'
  end

  describe 'action ::help::' do
    subject { get '/?text=help' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', "HELP:\n/#{ENV['COMMAND']} help -  give this hepd message\n/#{ENV['COMMAND']} get - give you the next chair, (dry does no affect anything)\n/#{ENV['COMMAND']} get dry - give you the next chair, (dry does no affect anything)\n/#{ENV['COMMAND']} who - give you the current chair\n/#{ENV['COMMAND']} list - give the enterely list of recorded people\n/#{ENV['COMMAND']} reset - removing all blacklisted people\n/#{ENV['COMMAND']} left - who could be the chair\n/#{ENV['COMMAND']} add - put a person to the blacklist\n/#{ENV['COMMAND']} add <T_1_WEEK = 604800, T_2_WEEKS = 1209600, T_3_WEEKS = 1814400> - indicate how long a person should stay on the blacklist\n/#{ENV['COMMAND']} blacklist - get blacklisted people with remain time\n"
  end

  describe 'action ::left::' do
    subject { get '/?text=left' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', "Leftovers => Alexandra, Joel, Krzysztof, Lukasz, Steve"
  end

  describe 'action ::reset::' do
    before { expect_any_instance_of(RedisProxy).to receive(:reset) }
    subject { get '/?text=reset' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', "RESET, white list was cleaned!"
  end

  describe 'action ::add::' do
    shared_examples 'give the leftovers list' do
      it_behaves_like 'success'
      it_behaves_like 'should have private message', '**Alexandra** was put in blacklist, Leftovers => Joel, Krzysztof, Lukasz, Steve'
    end

    before { expect_any_instance_of(RedisProxy).to receive(:add).with('Alexandra', time).and_call_original }

    context 'add' do
      let(:time) { nil }
      subject { get '/?text=add+Alexandra' }
      it_behaves_like 'give the leftovers list'
    end

    context 'add with time' do
      let(:time) { 1209600 }
      subject { get '/?text=add+Alexandra+1209600' }
      it_behaves_like 'give the leftovers list'
    end
  end

  describe 'action ::get::' do
    before { expect_any_instance_of(RedisProxy).to receive(:random_host) { 'Alexandra' } }
    context 'dry == false' do
      include_context 'should have public message', '@backend-devs @favreau **Alexandra** will be the chair of the next meeting'
      subject { get '/?text=get' }
      it_behaves_like 'success'
      it_behaves_like 'should have private message', "Leftovers => Joel, Krzysztof, Lukasz, Steve"
    end
    context 'dry == true' do
      include_context 'should have public message', '-dry mode- **Alexandra** will be the chair of the next meeting'
      subject { get '/?text=get+dry' }
      it_behaves_like 'success'
      it_behaves_like 'should have private message', "Leftovers => Alexandra, Joel, Krzysztof, Lukasz, Steve"
    end
  end
end
