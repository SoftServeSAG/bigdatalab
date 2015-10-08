require 'spec_helper'
require 'hiera'

describe 'profiles::log_generator' do

  context "when all parameters provided" do
    it { should compile }
  end

  context "as a linux-based role" do
    it { should contain_class('profiles::linux')}
  end

  context "before all other actions" do
    it { should contain_user('log_generator') }
    it { should contain_file('log_generator_home')}
  end

  context "to generate apache access logs" do
    it { should contain_class('log_generator::apache_access') }
    it { should contain_service('apache_access_log_generator') }
  end

  context "to generate apache access logs" do
    it { should contain_class('log_generator::apache_error') }
    it { should contain_service('apache_error_log_generator') }
  end

  context "to generate iostat logs" do
    it { should contain_class('log_generator::iostat') }
    it { should contain_service('iostat_log_generator') }
  end

  context "to generate vmstat logs" do
    it { should contain_class('log_generator::vmstat') }
    it { should contain_service('vmstat_log_generator') }
  end
  
  at_exit { RSpec::Puppet::Coverage.report! }

end