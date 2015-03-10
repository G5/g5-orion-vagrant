require 'yaml'

class ProjectDirectories
  attr_reader :projects

  def initialize
    @projects = {}
    @projects = YAML.load_file(projects_file) if projects_file
  end

  def each
    if block_given?
      projects.each_pair { |name, repo| yield name, repo }
    else
      projects.each_pair
    end
  end

  def self.vagrant_dir
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def self.working_dir(project_name)
    File.expand_path(File.join(vagrant_dir, '..', project_name))
  end

  private
  def projects_file
    if File.exist?('projects-override.yml')
      'projects-override.yml'
    elsif File.exist?('projects.yml')
      'projects.yml'
    end
  end
end
