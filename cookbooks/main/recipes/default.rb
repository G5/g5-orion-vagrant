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

[ "git", "nodejs", "vim", "libsqlite3-dev", "sqlite3"].each do |package_name|
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
  value "http://g5-configurator.dev/webhooks"
end
