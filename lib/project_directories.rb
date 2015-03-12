require 'yaml'

class ProjectDirectories
  attr_reader :projects

  def initialize
    @projects = load_projects || []
  end

  def self.vagrant_dir
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  class Project
    attr_reader :name, :repo

    def initialize(opts={})
      @name = opts[:name]
      @repo = opts[:repo]
    end

    def working_dir
      @working_dir ||=
        if name
          File.expand_path(File.join(ProjectDirectories.vagrant_dir, '..', name))
        end
    end

    def ruby_version
      @ruby_version ||= (rbenv_ruby_version || gemfile_ruby_version)
    end

    def ==(other)
      other.is_a?(Project) &&
        other.name == name &&
        other.repo == repo
    end

    private
    def rbenv_ruby_version
      rbenv_file = File.join(working_dir.to_s, '.ruby-version')
      File.read(rbenv_file).strip if File.exists?(rbenv_file)
    end

    def gemfile_ruby_version
      gemfile = File.join(working_dir.to_s, 'Gemfile')
      read_ruby_from_gemfile(gemfile) if File.exists?(gemfile)
    end

    def read_ruby_from_gemfile(gemfile)
      File.open gemfile do |file|
        ruby_directive = file.find { |line| line =~ /^\s*ruby/ }
        match = ruby_directive.to_s.match(/['"](.*)['"]\s*$/)
        match[1] if match
      end
    end
  end

  private
  def projects_file
    if File.exist?('projects-override.yml')
      'projects-override.yml'
    elsif File.exist?('projects.yml')
      'projects.yml'
    end
  end

  def load_projects
    if projects_file
      YAML.load_file(projects_file).collect do |name, repo|
        Project.new(name: name, repo: repo)
      end
    end
  end
end
