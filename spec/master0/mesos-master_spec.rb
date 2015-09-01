require 'spec_helper'

describe service('mesos-master') do
  it { should be_enabled   }
  it { should be_running   }
end

describe service('mesos-slave') do
  it { should_not be_running   }
end

describe port(5050) do
  it { should be_listening }
end

describe file('/etc/default/mesos') do
  it { should be_file }
  its(:content) { should match /IP=/ }
  its(:content) { should match /LOGS=/ }
  its(:content) { should match /ULIMIT=/ }
end

describe file('/etc/mesos/zk') do
  it { should be_file }
  its(:content) { should match /^zk:\/\/([\da-z\.\/:,-]+)([\/\da-z\.-]*)*\/?$/ }
end

describe file('/etc/mesos-master/work_dir') do
  it { should be_file }
  its(:content) { should match /var\/run\/mesos/ }
end

describe file('/etc/mesos-master/quorum') do
  it { should be_file }
  its(:content) { should match /1/ }
end

describe file('/etc/mesos-master/cluster') do
  it { should be_file }
  its(:content) { should match /vagrant-mesos-cluster/ }
end
