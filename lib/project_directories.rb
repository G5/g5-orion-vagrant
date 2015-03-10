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
      if !@version && working_dir
        version_file = File.join(working_dir, '.ruby-version')
        gemfile = File.join(working_dir, 'Gemfile')

        if File.exists?(version_file)
          @version = File.read(version_file).strip
        elsif File.exists?(gemfile)
          File.open gemfile do |file|
            file.find do |line|
               match = line.match(/ruby ['"](.*)['"]/)
               @version = match[1] if match
            end
          end
        end
      end

      @version
    end

    def ==(other)
      other.is_a?(Project) &&
        other.name == name &&
        other.repo == repo
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
