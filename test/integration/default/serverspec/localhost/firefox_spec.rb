require 'spec_helper'

describe 'Firefox' do
  describe command('which firefox') do
    its(:stdout) { is_expected.to match('/usr/local/bin/firefox')}
  end

  describe command('firefox -v') do
    its(:stdout) { is_expected.to match('Mozilla Firefox 31.5.0') }
  end
end
