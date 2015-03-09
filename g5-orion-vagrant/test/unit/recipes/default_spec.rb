#
# Cookbook Name:: g5-orion-vagrant
# Spec:: default
#
# Copyright (c) 2015 G5, All Rights Reserved.

require 'spec_helper'

describe 'g5-orion-vagrant::default' do
  before do
    stub_command('ls /var/lib/postgresql/9.3/main/recovery.conf').and_return('')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['postgresql']['password']['postgres'] = ''
    end.converge(described_recipe)
  end

  it 'converges successfully' do
    chef_run # This should not raise an error
  end

  it 'includes the g5stack::default recipe' do
    expect(chef_run).to include_recipe('g5stack::default')
  end

  it 'includes the g5stack::gitconfig recipe' do
    expect(chef_run).to include_recipe('g5stack::gitconfig')
  end

  context 'when firefox version is default' do
    it 'installs the firefox package with the default version' do
      expect(chef_run).to install_package('firefox').with_version('31.5.0esr')
    end
  end

  context 'when firefox version is custom' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['firefox']['version'] = firefox_version
      end.converge(described_recipe)
    end

    let(:firefox_version) { '34.0.5' }

    it 'installs the firefox package with the correct version' do
      expect(chef_run).to install_package('firefox').with_version(firefox_version)
    end
  end

  context 'when firefox version is latest' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['firefox']['version'] = 'latest'
      end.converge(described_recipe)
    end

    it 'includes the firefox::default recipe' do
      expect(chef_run).to include_recipe('firefox::default')
    end
  end
end
