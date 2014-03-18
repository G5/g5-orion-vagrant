#!/usr/bin/env ruby

# Initialize the git submodules for shared recipes
puts "Updating git submodules..."
`git submodule update --init --recursive`

# Configure ssh-agent
puts "Updating ssh-agent..."
`ssh-add`

# Clone the development repos
require 'yaml'

vagrant_dir = File.join(File.dirname(__FILE__), '..')
config_file = File.join(vagrant_dir, 'projects.yml')

YAML.load_file(config_file).each_pair do |project_name, project_git_url|
  working_dir = File.expand_path(File.join(vagrant_dir, '..', project_name))

  if File.exists?(working_dir)
    puts "Found existing directory for '#{project_name}'. Skipping..."
  else
    puts "Cloning '#{project_name}' into #{working_dir}"
    `git clone #{project_git_url} #{working_dir}`
  end
end
