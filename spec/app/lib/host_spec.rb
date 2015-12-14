require 'spec_helper'

describe Host do
  it {
    expect(Host.new.new_host).to match(/The new hoster is \*\*(?<host_name>.*)\*\*/)
  }
  it {
    expect(Host.new.new_host(Host::HOSTERS.sample)).to match(/The new hoster is \*\*(?<host_name>.*)\*\* and thank you _(?<previous_host>.*)_/)
  }
  it {
    expect(Host.new.list).to eql('List :: Alexandra, AntoineQ, Joel, Krzysztof, Lukasz, Steve')
  }
end
