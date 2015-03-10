require 'spec_helper'

describe 'Default editor' do
  describe package('vim') do
    it { is_expected.to be_installed }
  end

  describe command('update-alternatives --query editor') do
    its(:stdout) { is_expected.to match(/Value: \/usr\/bin\/vim.basic/) }
  end
end
