require 'spec_helper_acceptance'

describe 'roles::flume_collector class' do
  it 'should be idempotent' do
    pp = <<-EOS
      class { 'roles::flume_collector': }
    EOS
    apply_manifest(pp, :catch_failures => true)
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  end
  
  describe service('flume-agent') do
    it { should be_running }
    it { should be_enabled }
  end
  
  describe port(4545) do
    it { should be_listening }
  end

  describe port(4546) do
    it { should be_listening }
  end
end
