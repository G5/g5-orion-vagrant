require 'spec_helper'

describe 'Environment Variables' do
  let(:pre_command) { 'sudo -iu vagrant' }

  subject(:value) { command("#{pre_command} printenv | grep #{name}") }

  describe 'SECRET_TOKEN' do
    let(:name) { 'SECRET_TOKEN' }

    its(:stdout) { is_expected.to match(/^#{name}=[a-f0-9]{128}$/) }
  end 

  describe 'G5_CONFIGURATOR_WEBHOOK_URL' do
    let(:name) { 'G5_CONFIGURATOR_WEBHOOK_URL' }

    its(:stdout) { is_expected.to match(/^#{name}=http:\/\/g5-configurator\.herokuapp\.com\/consume_feed$/)}
  end

  describe 'HEROKU_APP_NAME' do
    let(:name) { 'HEROKU_APP_NAME' }

    its(:stdout) { is_expected.to match(/^#{name}=not-a-heroku-app$/) }
  end

  describe 'APP_DISPLAY_NAME' do
    let(:name) { 'APP_DISPLAY_NAME' }

    its(:stdout) { is_expected.to match(/^#{name}=G5 Client App Updater$/) }
  end

  describe 'G5_HUB_PORT' do
    let(:name) { 'G5_HUB_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3001$/) }
  end

  describe 'G5_CONFIGURATOR_PORT' do
    let(:name) { 'G5_CONFIGURATOR_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3002$/) }
  end

  describe 'G5_CLIENT_APP_CREATOR_PORT' do
    let(:name) { 'G5_CLIENT_APP_CREATOR_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3003$/) }
  end

  describe 'G5_LAYOUT_GARDEN_PORT' do
    let(:name) { 'G5_LAYOUT_GARDEN_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3004$/) }
  end

  describe 'G5_THEME_GARDEN_PORT' do
    let(:name) { 'G5_THEME_GARDEN_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3005$/) }
  end

  describe 'G5_WIDGET_GARDEN_PORT' do
    let(:name) { 'G5_WIDGET_GARDEN_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3006$/) }
  end

  describe 'G5_SIBLING_DEPLOYER_PORT' do
    let(:name) { 'G5_SIBLING_DEPLOYER_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3007$/) }
  end

  describe 'G5_CONTENT_MANAGEMENT_SYSTEM_PORT' do
    let(:name) { 'G5_CONTENT_MANAGEMENT_SYSTEM_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3008$/) }
  end

  describe 'G5_PHONE_NUMBER_SERVICE_PORT' do
    let(:name) { 'G5_PHONE_NUMBER_SERVICE_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3009$/) }
  end

  describe 'G5_PRICING_AND_AVAILABILITY_PORT' do
    let(:name) { 'G5_PRICING_AND_AVAILABILITY_PORT' }

    its(:stdout) { is_expected.to match(/^#{name}=3010$/) }
  end
end
