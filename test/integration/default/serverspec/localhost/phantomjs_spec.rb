require 'spec_helper'

describe 'PhantomJS' do
  describe command('which phantomjs') do
    its(:stdout) { is_expected.to match(/\A\S+\Z/) }
  end

  describe package('fontconfig') do
    it { is_expected.to be_installed }
  end

  describe package('libfreetype6') do
    it { is_expected.to be_installed }
  end
end
