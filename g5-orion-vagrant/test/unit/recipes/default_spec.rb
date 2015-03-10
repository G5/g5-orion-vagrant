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

  it 'includes the mozilla-firefox::default recipe' do
    expect(chef_run).to include_recipe('mozilla-firefox::default')
  end

  it 'sets the SECRET_TOKEN via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('SECRET_TOKEN')
  end

  it 'sets the G5_CONFIGURATOR_WEBHOOK_URL via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_CONFIGURATOR_WEBHOOK_URL')
  end

  it 'sets the HEROKU_APP_NAME via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('HEROKU_APP_NAME')
  end

  it 'sets the HEROKU_API_KEY via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('HEROKU_API_KEY')
  end

  it 'sets the HEROKU_USERNAME via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('HEROKU_USERNAME')
  end

  it 'sets the ID_RSA via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('ID_RSA')
  end

  it 'sets the HEROKU_REPO via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('HEROKU_REPO')
  end

  it 'sets the GITHUB_REPO via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('GITHUB_REPO')
  end

  it 'sets the APP_DISPLAY_NAME via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('APP_DISPLAY_NAME')
  end

  it 'sets the AWS_ACCESS_KEY_ID via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('AWS_ACCESS_KEY_ID')
  end

  it 'sets the AWS_SECRET_ACCESS_KEY via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('AWS_SECRET_ACCESS_KEY')
  end

  it 'sets the AWS_REGION via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('AWS_REGION')
  end

  it 'sets the G5_HUB_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_HUB_PORT')
  end

  it 'sets the G5_CONFIGURATOR_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_CONFIGURATOR_PORT')
  end

  it 'sets the G5_CLIENT_APP_CREATOR_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_CLIENT_APP_CREATOR_PORT')
  end

  it 'sets the G5_LAYOUT_GARDEN_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_LAYOUT_GARDEN_PORT')
  end

  it 'sets the G5_THEME_GARDEN_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_THEME_GARDEN_PORT')
  end

  it 'sets the G5_WIDGET_GARDEN_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_WIDGET_GARDEN_PORT')
  end

  it 'sets the G5_CONTENT_MANAGEMENT_SYSTEM_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_CONTENT_MANAGEMENT_SYSTEM_PORT')
  end

  it 'sets the G5_PHONE_NUMBER_SERVICE_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_PHONE_NUMBER_SERVICE_PORT')
  end

  it 'sets the G5_PRICING_AND_AVAILABILITY_PORT via magic_shell' do
    expect(chef_run).to add_magic_shell_environment('G5_PRICING_AND_AVAILABILITY_PORT')
  end
end
