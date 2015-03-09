require 'spec_helper'

describe 'Firefox' do
  describe package('firefox') do
    it { is_expected.to be_installed }
  end

  describe command('firefox -v') do
    its(:stdout) { is_expected.to match(/Mozilla Firefox 31.5.0esr/) }
  end
end
