require 'spec_helper'

describe 'git' do
  describe package('git') do
    it { is_expected.to be_installed }
  end
 
  describe 'config' do
    subject(:git_config) { command("git config #{config_opt}") }

    describe 'user.name' do
      let(:config_opt) { 'user.name' }

      its(:stdout) { is_expected.to match(/\A\S+\Z/) }
    end

    describe 'user.email' do
      let(:config_opt) { 'user.email' }

      its(:stdout) { is_expected.to match(/\A\S+\Z/) }
    end

    describe 'color.ui' do
      let(:config_opt) { 'color.ui' }

      its(:stdout) { is_expected.to match('auto') }
    end

    describe 'push.default' do
      let(:config_opt) { 'push.default' }

      its(:stdout) { is_expected.to match('current') }
    end
  end
end
