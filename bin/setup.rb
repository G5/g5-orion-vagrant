#!/usr/bin/env ruby

# Configure ssh-agent
puts "Updating ssh-agent..."
`ssh-add`

# Install required cookbooks
puts "Installing cookbook dependencies..."
`chef exec berks install`

# Install required vagrant plugins
puts "Managing vagrant plugins (this could take a while)..."
def install_vagrant_plugin(plugin_name, plugin_version=nil)
  plugin_opts = "--plugin-version='#{plugin_version}'" if plugin_version
  match_data = `vagrant plugin list`.match(/#{plugin_name} \(([\d.]+)\)/m)

  if !match_data || (plugin_version && match_data[1] != plugin_version)
    `vagrant plugin install #{plugin_name} #{plugin_opts}`
  elsif !plugin_version
    `vagrant plugin update #{plugin_name}`
  end
end
install_vagrant_plugin('vagrant-vbguest')
install_vagrant_plugin('vagrant-berkshelf', '>= 4.0.3')

# Clone the development repos
puts "Cloning project repositories..."
require_relative '../lib/project_directories'

ProjectDirectories.new.projects.each do |project|
  if File.exists?(project.working_dir)
    puts "Found existing directory for '#{project.name}'. Skipping."
  else
    puts "Cloning #{project.name} into #{project.working_dir}"
    `git clone #{project.repo} #{project.working_dir}`
  end
end

# Check for potential berkshelf collision
unless `gem list berkshelf`.chomp.empty?
  puts "\nWARNING: You previously installed berkshelf as a gem, but "
  puts "vagrant-berkshelf requires the version of berkshelf included "
  puts "with ChefDK. Consider uninstalling the berkshelf gem, or "
  puts "execute all vagrant commands through chef exec, e.g.:"
  puts ""
  puts "    chef exec vagrant up "
end
