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
    it_behaves_like 'should have private message', "unknow action => 'unknow'\n\nHELP:\n/meeting help\n/meeting get dry\n/meeting list\n/meeting reset\n/meeting left\n"
  end

  describe 'action ::list::' do
    include_context 'should have public message', nil
    subject { get '/?text=list' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', 'List :: Alexandra, AntoineQ, Joel, Krzysztof, Lukasz, Steve'
  end

  describe 'action ::help::' do
    include_context 'should have public message', nil
    subject { get '/?text=help' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', "HELP:\n/meeting help\n/meeting get dry\n/meeting list\n/meeting reset\n/meeting left\n"
  end

  describe 'action ::left::' do
    include_context 'should have public message', nil
    subject { get '/?text=left' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', "Leftovers => Alexandra, AntoineQ, Joel, Krzysztof, Lukasz, Steve"
  end

  describe 'action ::reset::' do
    include_context 'should have public message', nil
    subject { get '/?text=reset' }
    it_behaves_like 'success'
    it_behaves_like 'should have private message', "RESET, white list was cleaned!"
  end

  describe 'action ::get::' do
    before { expect_any_instance_of(RedisProxy).to receive(:random_host) { 'Alexandra' } }
    context 'dry == false' do
      before { expect(RedisProxy).to receive(:new).with(false).and_call_original }
      include_context 'should have public message', '**Alexandra** will host the next meeting'
      subject { get '/?text=get' }
      it_behaves_like 'success'
      it_behaves_like 'should have private message', "Leftovers => AntoineQ, Joel, Krzysztof, Lukasz, Steve"
    end
    context 'dry == true' do
      before { expect(RedisProxy).to receive(:new).with(true).and_call_original }
      include_context 'should have public message', '**Alexandra** will host the next meeting'
      subject { get '/?text=get+dry' }
      it_behaves_like 'success'
      it_behaves_like 'should have private message', "Leftovers => Alexandra, AntoineQ, Joel, Krzysztof, Lukasz, Steve"
    end
  end
end
