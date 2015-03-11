#
# Cookbook Name:: g5-orion-vagrant
# Recipe:: default
#
# Copyright (c) 2015 G5, All Rights Reserved.
include_recipe 'g5stack'
include_recipe 'g5stack::gitconfig'
include_recipe 'mozilla-firefox'

node['rbenv']['ruby_versions'].each do |ruby_ver|
  rbenv_ruby ruby_ver
end

node['g5-orion-vagrant']['env'].each_pair do |key, val|
  magic_shell_environment key.upcase do
    value val
  end
end
