require 'spec_helper_acceptance'

describe 'roles::elasticsearch class' do
  it 'should be idempotent' do
    pp = <<-EOS
      class { 'roles::elasticsearch': }
    EOS
    apply_manifest(pp, :catch_failures => true)
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  end
  
  describe service('elasticsearch-es-01') do
    it { should be_running }
  end
  
  describe port(9200) do
    it { should be_listening }
  end
end
