require 'spec_helper'

shared_examples 'success' do
  specify { expect(subject.status).to eq(200) }
end

shared_examples 'match' do |message|
  specify do
    expect(JSON.parse(subject.body)['text']).to  match(message)
  end
end

describe HostApp, type: :controller do
  describe 'Random choose' do
    subject { post '/' }
    it_behaves_like 'success'
    it_behaves_like 'match', /The new hoster is \*\*(?<host_name>.*)\*\*/
  end
  describe 'without previous host' do
    subject { post '/?text=Joel' }
    it_behaves_like 'success'
    it_behaves_like 'match', /The new hoster is \*\*(?<host_name>.*)\*\* and thank you _Joel_/
  end
  describe 'get a list of hosts' do
    subject { post '/?text=list' }
    it_behaves_like 'success'
    it_behaves_like 'match', /List :: Alexandra, AntoineQ, Joel, Krzysztof, Lukasz, Stev/
  end
end
