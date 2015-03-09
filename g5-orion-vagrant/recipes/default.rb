#
# Cookbook Name:: g5-orion-vagrant
# Recipe:: default
#
# Copyright (c) 2015 G5, All Rights Reserved.
include_recipe 'g5stack'
include_recipe 'g5stack::gitconfig'

# The firefox cookbook doesn't respect the firefox version attribute for linux systems,
# because only the latest version is available via apt. It's important to pin firefox
# to a compatible version for selenium-webdriver, so we'll have to install it ourselves
# from the Mozilla CDN
if node['firefox']['version'] == 'latest'
  include_recipe 'firefox'
else
  version = node['firefox']['version']
  base_url = "#{node['firefox']['releases_url']}/#{version}/linux-x86_64/#{node['firefox']['lang']}"
  package_name = "firefox-#{version}.tar.bz2"

  remote_file "#{Chef::Config[:file_cache_path]}/#{package_name}" do
    source "#{base_url}/#{package_name}"
    checksum node['firefox']['checksum']
    notifies :run, 'bash[install_firefox]', :immediately
  end

  bash 'install_firefox' do
    user 'root'
    cwd Chef::Config[:file_cache_path]
    code <<-HERE
      # TODO
    HERE
    action :nothing
  end
end
