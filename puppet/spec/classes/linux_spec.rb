require 'spec_helper'
require 'hiera'

describe 'profiles::linux' do
  
  context "when running on unsupported OS" do
      let(:facts) { {
        :operatingsystem => 'Ubuntu'
      } }
      it { should_not compile }
  end

  context "when running on unsupported OS version" do
    let(:facts) { {
      :operatingsystemmajrelease => '5',
      :operatingsystemrelease    => '5.11'
    } }
    it { should_not compile }
  end

  context "as a base role for any linux node" do
    it { should contain_class('profiles::common') }
  end

  context "as a common practice for Hadoop setup" do
    it { should contain_class('selinux').with_mode('disabled') }
  end

  context "to be able to run Java applications" do
    it { should contain_class('jdk_oracle') }
  end

  context "to enable web downloads from bash scripts" do
    it { should contain_package('wget').with_ensure('present') }
  end

  context "to enable time synchronization on all nodes" do
    it { should contain_class('ntp') }
  end

  context "to enable puppetlabs package repository" do
    it { should contain_yumrepo('puppetlabs').with_timeout(300) }
  end

  at_exit { RSpec::Puppet::Coverage.report! }

end
