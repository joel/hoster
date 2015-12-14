require 'spec_helper'

shared_examples 'success' do
  specify { expect(subject.status).to eq(200) }
end

shared_examples 'ok' do
  specify { expect(subject.body).to eql('ok') }
end

describe HostApp, type: :controller do
  before do
    expect_any_instance_of(Slack::Poster).to receive(:send_message).with('mocked message')
  end

  describe 'Random choose' do
    subject { get '/' }
    before { expect_any_instance_of(Host).to receive(:new_host).with(any_args) { 'mocked message' } }
    it_behaves_like 'success'
    it_behaves_like 'ok'
  end

  describe 'without previous host' do
    subject { get '/?text=Joel' }
    before { expect_any_instance_of(Host).to receive(:new_host).with('Joel') { 'mocked message' } }
    it_behaves_like 'success'
    it_behaves_like 'ok'
  end

  describe 'get a list of hosts' do
    subject { get '/?text=list' }
    before { expect_any_instance_of(Host).to receive(:list).with(no_args) { 'mocked message' } }
    it_behaves_like 'success'
    it_behaves_like 'ok'
  end
end
