require 'spec_helper'

describe 'nodejs' do
  let(:pre_command) { 'sudo -iu vagrant' }

  describe 'package' do
    subject(:node) { package('nodejs') }

    it { is_expected.to be_installed }
  end

  describe 'npm' do
    subject(:npm) { command("#{pre_command} npm --help") }

    its(:stdout) { is_expected.to match(/Usage: npm/) }
  end

  describe 'global prefix dir' do
    subject(:node_modules) { file('/home/vagrant/.node') }

    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by('nobody') }
    it { is_expected.to be_grouped_into('vagrant') }
    it { is_expected.to be_writable.by('group') }
  end

  describe 'npm cache' do
    subject(:npm_cache) { file('/home/vagrant/.npm') }

    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by('vagrant') }
    it { is_expected.to be_grouped_into('vagrant') }

    it 'should be empty' do
      expect(command('ls /home/vagrant/.npm | wc -l').stdout).to match(/^0$/)
    end
  end
end
