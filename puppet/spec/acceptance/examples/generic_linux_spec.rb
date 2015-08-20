require 'spec_helper_acceptance'

describe 'roles::generic_linux class' do
  it 'should install role with no errors' do
    pp = <<-EOS
      class { 'roles::generic_linux': }
    EOS

    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  end

  describe selinux do
    it { should be_disabled }
  end

  describe service('ntp') do
    it { should be_running }
  end

  describe yumrepo('puppetlabs') do
    it { should be_enabled }
  end

  describe package('wget') do
    it { should be_installed }
  end

  describe command('java -v') do
    it { should contain('Java HotSpot(TM')}
  end

end