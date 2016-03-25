require 'spec_helper'
require 'hiera'

describe 'profiles::flume_collector' do

  context "as being linux-based" do
    it { should contain_class('profiles::linux') }
  end

  context "to install flume required bigtop repo" do
    it { should contain_class('bigtop_repo') }
  end

  context "flume use maven module as dependency" do
    it { should contain_class('maven::maven') }
  end

  context "include flume::collector module" do
    it { should contain_class('flume::collector') }
  end

  at_exit { RSpec::Puppet::Coverage.report! }

end
