execute "Update Package List" do
  command "apt-get update"
end

include_recipe "sane_postgresql"

include_recipe "vagrant_rbenv"
# Pre-install all required rubies
rubies = node[:rbenv][:ruby_versions]

global_ruby = node[:rbenv][:global_ruby_version].strip
rubies << global_ruby unless rubies.include?(global_ruby)

rubies.each do |ruby_ver|
  rbenv_ruby ruby_ver do
    global(ruby_ver == global_ruby)
  end

  rbenv_gem "bundler" do
    ruby_version ruby_ver
  end
end

["git", "nodejs", "redis-server", "vim", "libsqlite3-dev", "sqlite3", "firefox"].each do |package_name|
  package package_name
end

execute "Set default editor" do
  command "update-alternatives --set editor #{node[:editor][:default]}"
end

template "/home/vagrant/.gitconfig" do
  source "gitconfig.erb"
  mode 0640
  owner "vagrant"
  group "vagrant"
  variables({
     :user_name => node[:git][:user][:name],
     :user_email => node[:git][:user][:email],
     :color_ui => node[:git][:color][:ui],
     :push_default => node[:git][:push][:default]
  })
end

include_recipe "phantomjs::default"

magic_shell_environment "SECRET_TOKEN" do
  value SecureRandom.hex(64)
end

magic_shell_environment "G5_CONFIGURATOR_WEBHOOK_URL" do
  value "http://g5-configurator.herokuapp.com/consume_feed"
end

magic_shell_environment "LAYOUT_GARDEN_URL" do
  value "http://g5-layout-garden.herokuapp.com/"
end

magic_shell_environment "THEME_GARDEN_URL" do
  value "http://g5-theme-garden.herokuapp.com/"
end

magic_shell_environment "WIDGET_GARDEN_URL" do
  value "http://g5-widget-garden.herokuapp.com/"
end

magic_shell_environment "HEROKU_APP_NAME" do
  value "not-a-heroku-app"
end

magic_shell_environment "HEROKU_API_KEY" do
  value `echo $HEROKU_API_KEY`
end

magic_shell_environment "HEROKU_USERNAME" do
  value `echo $HEROKU_USERNAME`
end

magic_shell_environment "ID_RSA" do
  value `echo $ID_RSA`
end

magic_shell_environment "HEROKU_REPO" do
  value `echo $HEROKU_REPO`
end

magic_shell_environment "GITHUB_REPO" do
  value `echo $GITHUB_REPO`
end

magic_shell_environment "APP_DISPLAY_NAME" do
  value "G5 Client App Updater"
end

magic_shell_environment "AWS_ACCESS_KEY_ID" do
  value `echo $AWS_ACCESS_KEY_ID`
end

magic_shell_environment "AWS_SECRET_ACCESS_KEY" do
  value `echo $AWS_SECRET_ACCESS_KEY`
end

magic_shell_environment "AWS_REGION" do
  value `echo $AWS_REGION`
end

magic_shell_environment "G5_HUB_PORT" do
  value "3001"
end

magic_shell_environment "G5_CONFIGURATOR_PORT" do
  value "3002"
end

magic_shell_environment "G5_CLIENT_APP_CREATOR_PORT" do
  value "3003"
end

magic_shell_environment "G5_LAYOUT_GARDEN_PORT" do
  value "3004"
end

magic_shell_environment "G5_THEME_GARDEN_PORT" do
  value "3005"
end

magic_shell_environment "G5_WIDGET_GARDEN_PORT" do
  value "3006"
end

magic_shell_environment "G5_SIBLING_DEPLOYER_PORT" do
  value "3007"
end

magic_shell_environment "G5_CONTENT_MANAGEMENT_SYSTEM_PORT" do
  value "3008"
end

magic_shell_environment "G5_PHONE_NUMBER_SERVICE_PORT" do
  value "3009"
end

magic_shell_environment "G5_PRICING_AND_AVAILABILITY_PORT" do
  value "3010"
end
