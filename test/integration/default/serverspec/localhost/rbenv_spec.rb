require 'spec_helper'

describe 'rbenv' do
  let(:pre_command) { 'sudo -iu vagrant' }

  describe 'executable' do
    subject(:rbenv) { command("#{pre_command} which rbenv") }

    its(:stdout) { is_expected.to match('/opt/rbenv/bin/rbenv') }
  end

  describe 'directory' do
    subject(:rbenv) { file('/opt/rbenv/') }

    it { is_expected.to be_grouped_into('rbenv') }
    it { is_expected.to be_readable.by_user('vagrant') }
    it { is_expected.to be_writable.by_user('vagrant') }
    it { is_expected.to be_executable.by_user('vagrant') }
  end

  describe 'default ruby executable' do
    subject(:ruby) { command("#{pre_command} which ruby") }

    its(:stdout) { is_expected.to match('/opt/rbenv/shims/ruby') }
  end

  describe 'default ruby version' do
    subject(:ruby_version) { command("#{pre_command} ruby -v") }

    its(:stdout) { is_expected.to match(/ruby 2\.2\.0/) }
  end

  describe 'bundler' do
    subject(:bundler) { command("#{pre_command} which bundle") }

    its(:stdout) { is_expected.to match('/opt/rbenv/shims/bundle') }
  end

  describe 'PATH env var' do
    subject(:path) { command("#{pre_command} printenv") }

    it 'should favor local project binstubs over rbenv shims' do
      expect(path.stdout).to match(/PATH=bin\:.*\/opt\/rbenv\/shims/)
    end
  end

  describe 'rubygems' do
    subject(:rubygems) { command("#{pre_command} gem install rubygems-update") }

    it 'should allow the vagrant user to install gems' do
      expect(rubygems.stdout).to match(/1 gem installed/)
    end
  end
end
