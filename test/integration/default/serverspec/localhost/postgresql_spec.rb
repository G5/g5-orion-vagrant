require 'spec_helper'

describe 'PostgreSQL' do
  describe service('postgresql') do
    it { is_expected.to be_enabled }
  end

  describe process('postgres') do
    it { is_expected.to be_running }
    its(:user) { is_expected.to eq('postgres') }
  end

  describe port(5432) do
    it { is_expected.to be_listening }
  end

  describe 'client version' do
    subject(:client_version) { command('psql --version') }

    its(:stdout) { should match(/psql \(PostgreSQL\) 9\.3/) }
  end

  describe 'server version' do
    subject(:server_version) { command('sudo -u postgres psql -c "select version();"') }

    its(:stdout) { is_expected.to match(/PostgreSQL 9\.3/) }
  end

  describe 'vagrant db role' do
    subject(:vagrant_role) { command("sudo -u postgres psql -c \"SELECT rolname FROM pg_roles WHERE rolname='vagrant'\"") }

    its(:stdout) { is_expected.to match(/vagrant/) }
  end

  describe package('postgresql-contrib-9.3') do
    it { is_expected.to be_installed }
  end
end
