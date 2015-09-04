require 'spec_helper'
require 'hiera'

describe 'profiles::elasticsearch' do
  
  let(:facts) { {
    :memorysize_mb => 4096,
    :kernel        => 'Linux'
  } }
  
  context "as being linux-based" do
    it { should contain_class('profiles::linux') }
  end
  
  context "since using elasticsearch module" do
    it { should contain_class('elasticsearch') }
  end
  
  at_exit { RSpec::Puppet::Coverage.report! }
  
end
