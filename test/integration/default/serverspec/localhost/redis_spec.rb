require 'spec_helper'

describe 'Redis' do
  describe service('redis6379') do
    it { is_expected.to be_enabled }
  end

  describe process('redis-server') do
    it { is_expected.to be_running }
    its(:user) { is_expected.to eq('redis') }
  end

  describe port(6379) do
    it { is_expected.to be_listening }
  end
end
