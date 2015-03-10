require 'spec_helper'

describe 'SQLite' do
  describe package('sqlite3') do
    it { is_expected.to be_installed }
  end

  describe package('libsqlite3-dev') do
    it { is_expected.to be_installed }
  end
end
