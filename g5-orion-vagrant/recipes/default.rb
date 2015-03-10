#
# Cookbook Name:: g5-orion-vagrant
# Recipe:: default
#
# Copyright (c) 2015 G5, All Rights Reserved.
include_recipe 'g5stack'
include_recipe 'g5stack::gitconfig'
include_recipe 'mozilla-firefox'

magic_shell_environment 'SECRET_TOKEN' do
  value SecureRandom.hex(64)
end

magic_shell_environment 'G5_CONFIGURATOR_WEBHOOK_URL' do
  value 'http://g5-configurator.herokuapp.com/consume_feed'
end

magic_shell_environment 'HEROKU_APP_NAME' do
  value 'not-a-heroku-app'
end

magic_shell_environment 'APP_DISPLAY_NAME' do
  value 'G5 Client App Updater'
end

magic_shell_environment 'G5_HUB_PORT' do
  value '3001'
end

magic_shell_environment 'G5_CONFIGURATOR_PORT' do
  value '3002'
end

magic_shell_environment 'G5_CLIENT_APP_CREATOR_PORT' do
  value '3003'
end

magic_shell_environment 'G5_LAYOUT_GARDEN_PORT' do
  value '3004'
end

magic_shell_environment 'G5_THEME_GARDEN_PORT' do
  value '3005'
end

magic_shell_environment 'G5_WIDGET_GARDEN_PORT' do
  value '3006'
end

magic_shell_environment 'G5_SIBLING_DEPLOYER_PORT' do
  value '3007'
end

magic_shell_environment 'G5_CONTENT_MANAGEMENT_SYSTEM_PORT' do
  value '3008'
end

magic_shell_environment 'G5_PHONE_NUMBER_SERVICE_PORT' do
  value '3009'
end

magic_shell_environment 'G5_PRICING_AND_AVAILABILITY_PORT' do
  value '3010'
end

# Pretty sure these aren't really doing what the original dev thought
# they were doing, but maintaining them for now
magic_shell_environment "HEROKU_API_KEY" do
  value `echo $HEROKU_API_KEY`
end

magic_shell_environment 'HEROKU_USERNAME' do
  value `echo $HEROKU_USERNAME`
end

magic_shell_environment 'ID_RSA' do
  value `echo $ID_RSA`
end

magic_shell_environment 'HEROKU_REPO' do
  value `echo $HEROKU_REPO`
end

magic_shell_environment 'GITHUB_REPO' do
  value `echo $GITHUB_REPO`
end

magic_shell_environment 'AWS_ACCESS_KEY_ID' do
  value `echo $AWS_ACCESS_KEY_ID`
end

magic_shell_environment 'AWS_SECRET_ACCESS_KEY' do
  value `echo $AWS_SECRET_ACCESS_KEY`
end

magic_shell_environment 'AWS_REGION' do
  value `echo $AWS_REGION`
end
