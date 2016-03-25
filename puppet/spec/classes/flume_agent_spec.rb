require 'spec_helper'
require 'hiera'

describe 'profiles::flume_agent' do
 
  context "as being linux-based" do
    it { should contain_class('profiles::linux') }
  end
  
  context "since using elasticsearch module" do
    it { should contain_class('bigtop_repo') }
  end

  context "include flume::agent module " do
    it { should contain_class('flume::agent') }
  end
  
  at_exit { RSpec::Puppet::Coverage.report! }
  
end
