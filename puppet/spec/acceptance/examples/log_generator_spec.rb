require 'spec_helper_acceptance'

describe 'roles::log_generator class' do
  it 'should be idempotent' do
    pp = <<-EOS
      class { 'roles::log_generator': }
    EOS
    apply_manifest(pp, :catch_failures => true)
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  end

  describe service('apache_access_log_generator') do
    it { should be_running }
  end

  describe command('nc -l 5001 | wc -l') do
     its(:stdout) { should eq "0\n" }
  end

  describe service('apache_error_log_generator') do
    it { should be_running }
  end

  describe command('nc -l 5002 | wc -l') do
     its(:stdout) { should eq "0\n" }
  end

  describe service('iostat_log_generator') do
    it { should be_running }
  end

  describe command('nc -l 33302 | wc -l') do
     its(:stdout) { should eq "11\n" }
  end

  describe service('vmstat_log_generator') do
    it { should be_running }
  end

  describe command('nc -l 33303 | wc -l') do
     its(:stdout) { should eq "3\n" }
  end

end
