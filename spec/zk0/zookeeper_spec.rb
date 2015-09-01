require 'spec_helper'

describe service('zookeeper') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(2181) do
  it { should be_listening }
end

describe file('/var/lib/zookeeper/myid') do
  it { should be_file }
  its(:content) { should match /1/ }
end
