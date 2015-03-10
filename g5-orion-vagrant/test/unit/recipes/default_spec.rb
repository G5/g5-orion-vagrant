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

  context 'with non-default list of rubies' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['rbenv']['ruby_versions'] = ['2.1.2', '2.1.5']
      end.converge(described_recipe)
    end

    it 'installs 2.1.2 via rbenv' do
      expect(chef_run).to install_rbenv_ruby('2.1.2')
    end

    it 'installs 2.1.5 via rbenv' do
      expect(chef_run).to install_rbenv_ruby('2.1.5')
    end
  end

  context 'with default environment config' do
    it 'sets the SECRET_TOKEN via magic_shell' do
      expect(chef_run).to add_magic_shell_environment('SECRET_TOKEN')
    end

    it 'sets the G5_CONFIGURATOR_WEBHOOK_URL via magic_shell' do
      expect(chef_run).to add_magic_shell_environment('G5_CONFIGURATOR_WEBHOOK_URL')
    end

    it 'sets the HEROKU_APP_NAME via magic_shell' do
      expect(chef_run).to add_magic_shell_environment('HEROKU_APP_NAME')
    end

    it 'sets the APP_DISPLAY_NAME via magic_shell' do
      expect(chef_run).to add_magic_shell_environment('APP_DISPLAY_NAME')
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

    it 'sets the G5_SIBLING_DEPLOYER_PORT via magic_shell' do
      expect(chef_run).to add_magic_shell_environment('G5_SIBLING_DEPLOYER_PORT')
    end
  end

  context 'with non-default SECRET_TOKEN' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['secret_token'] = secret_token
      end.converge(described_recipe)
    end
    let(:secret_token) { 'foobar123' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('SECRET_TOKEN').with_value(secret_token)
    end
  end

  context 'with non-default G5_CONFIGURATOR_WEBHOOK_URL' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_configurator_webhook_url'] = webhook_url
      end.converge(described_recipe)
    end
    let(:webhook_url) { 'http://test.host/my_action' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_CONFIGURATOR_WEBHOOK_URL').with_value(webhook_url)
    end
  end

  context 'with non-default HEROKU_APP_NAME' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['heroku_app_name'] = app_name
      end.converge(described_recipe)
    end
    let(:app_name) { 'some-brand-new-heroku-app-name' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('HEROKU_APP_NAME').with_value(app_name)
    end
  end

  context 'with non-default APP_DISPLAY_NAME' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['app_display_name'] = app_name
      end.converge(described_recipe)
    end
    let(:app_name) { 'My Custom App Name' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('APP_DISPLAY_NAME').with_value(app_name)
    end
  end

  context 'with non-default HEROKU_API_KEY' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['heroku_api_key'] = api_key
      end.converge(described_recipe)
    end
    let(:api_key) { 'custom-api-key' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('HEROKU_API_KEY').with_value(api_key)
    end
  end

  context 'with non-default HEROKU_USERNAME' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['heroku_username'] = username
      end.converge(described_recipe)
    end
    let(:username) { 'custom-heroku-user' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('HEROKU_USERNAME').with_value(username)
    end
  end

  context 'with non-default ID_RSA' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['id_rsa'] = id_rsa
      end.converge(described_recipe)
    end
    let(:id_rsa) { 'custom-id-rsa' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('ID_RSA').with_value(id_rsa)
    end
  end

  context 'with non-default HEROKU_REPO' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['heroku_repo'] = repo
      end.converge(described_recipe)
    end
    let(:repo) { 'custom-heroku-repo' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('HEROKU_REPO').with_value(repo)
    end
  end

  context 'with non-default GITHUB_REPO' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['github_repo'] = repo
      end.converge(described_recipe)
    end
    let(:repo) { 'custom-github-repo' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('GITHUB_REPO').with_value(repo)
    end
  end

  context 'with non-default HEROKU_USERNAME' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['heroku_username'] = username
      end.converge(described_recipe)
    end
    let(:username) { 'custom-heroku-user' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('HEROKU_USERNAME').with_value(username)
    end
  end

  context 'with non-default AWS_ACCESS_KEY_ID' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['aws_access_key_id'] = key_id
      end.converge(described_recipe)
    end
    let(:key_id) { 'custom-access-key-id' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('AWS_ACCESS_KEY_ID').with_value(key_id)
    end
  end

  context 'with non-default AWS_SECRET_ACCESS_KEY' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['aws_secret_access_key'] = access_key
      end.converge(described_recipe)
    end
    let(:access_key) { 'custom-secret-access-key' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('AWS_SECRET_ACCESS_KEY').with_value(access_key)
    end
  end

  context 'with non-default AWS_REGION' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['aws_region'] = region
      end.converge(described_recipe)
    end
    let(:region) { 'custom-region' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('AWS_REGION').with_value(region)
    end
  end

  context 'with non-default G5_HUB_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_hub_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9001' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_HUB_PORT').with_value(port)
    end
  end

  context 'with non-default G5_CONFIGURATOR_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_configurator_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9002' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_CONFIGURATOR_PORT').with_value(port)
    end
  end

  context 'with non-default G5_CLIENT_APP_CREATOR_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_client_app_creator_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9003' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_CLIENT_APP_CREATOR_PORT').with_value(port)
    end
  end

  context 'with non-default G5_LAYOUT_GARDEN_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_layout_garden_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9004' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_LAYOUT_GARDEN_PORT').with_value(port)
    end
  end

  context 'with non-default G5_THEME_GARDEN_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_theme_garden_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9005' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_THEME_GARDEN_PORT').with_value(port)
    end
  end

  context 'with non-default G5_WIDGET_GARDEN_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_widget_garden_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9006' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_WIDGET_GARDEN_PORT').with_value(port)
    end
  end

  context 'with non-default G5_CONTENT_MANAGEMENT_SYSTEM_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_content_management_system_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9007' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_CONTENT_MANAGEMENT_SYSTEM_PORT').with_value(port)
    end
  end

  context 'with non-default G5_PHONE_NUMBER_SERVICE_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_phone_number_service_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9008' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_PHONE_NUMBER_SERVICE_PORT').with_value(port)
    end
  end

  context 'with non-default G5_PRICING_AND_AVAILABILITY_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_pricing_and_availability_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9009' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_PRICING_AND_AVAILABILITY_PORT').with_value(port)
    end
  end

  context 'with non-default G5_SIBLING_DEPLOYER_PORT' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['postgresql']['password']['postgres'] = ''
        node.set['g5-orion-vagrant']['env']['g5_sibling_deployer_port'] = port
      end.converge(described_recipe)
    end
    let(:port) { '9010' }

    it 'sets the environment variable with the custom value' do
      expect(chef_run).to add_magic_shell_environment('G5_SIBLING_DEPLOYER_PORT').with_value(port)
    end
  end
end
