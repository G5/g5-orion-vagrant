require 'spec_helper'
require 'project_directories'

describe ProjectDirectories do
  include FakeFS::SpecHelpers

  let(:projects) do
    {'main-app' => 'repo.url',
     'auxiliary_gem_project' => 'gem.repo.url'}
  end

  let(:overrides) do
    {'my-custom-project' => 'my-repo-url',
     'my-other-custom-project' => 'my-other-repo-url'}
  end

  before do
    File.delete('projects.yml') if File.exist?('projects.yml')
    File.delete('projects-override.yml') if File.exist?('projects-override.yml')
  end

  describe '#projects' do
    subject(:project_entries) { ProjectDirectories.new.projects }

    context 'with projects-override.yml' do
      before do
        File.open('projects-override.yml', 'w') { |f| f.write overrides.to_yaml }
        File.open('projects.yml', 'w') { |f| f.write projects.to_yaml }
      end

      it 'should have 2 projects' do
        expect(project_entries.size).to eq(2)
      end

      it 'should have an entry for the first custom project' do
        project_obj = ProjectDirectories::Project.new(name: 'my-custom-project', repo: 'my-repo-url')
        expect(project_entries).to include(project_obj)
      end

      it 'should have an entry for the second custom project' do
        project_obj = ProjectDirectories::Project.new(name: 'my-other-custom-project', repo: 'my-other-repo-url')
        expect(project_entries).to include(project_obj)
      end
    end

    context 'with projects.yml' do
      before do
        File.open('projects.yml', 'w') { |f| f.write projects.to_yaml }
      end

      it 'should have 2 projects' do
        expect(project_entries.size).to eq(2)
      end

      it 'should have an entry for the first standard project' do
        project_obj = ProjectDirectories::Project.new(name: 'main-app', repo: 'repo.url')
        expect(project_entries).to include(project_obj)
      end

      it 'should have an entry for the second standard project' do
        project_obj = ProjectDirectories::Project.new(name: 'auxiliary_gem_project', repo: 'gem.repo.url')
        expect(project_entries).to include(project_obj)
      end
    end

    context 'without a projects file' do
      it 'should have no projects' do
        expect(project_entries).to be_empty
      end
    end
  end

  describe '.vagrant_dir' do
    let(:vagrant_dir) { ProjectDirectories.vagrant_dir }

    it 'should be the fully qualified path to the vagrant root' do
      relative_dir = File.join(__FILE__, '..', '..', '..', '..')
      expect(vagrant_dir).to eq(File.expand_path(relative_dir))
    end
  end

  describe ProjectDirectories::Project do
    subject { project }

    context 'with default initialization' do
      let(:project) { ProjectDirectories::Project.new }

      it 'should have a nil name' do
        expect(project.name).to be_nil
      end

      it 'should have a nil repo' do
        expect(project.repo).to be_nil
      end

      it 'should have a nil working_dir' do
        expect(project.working_dir).to be_nil
      end

      it 'should have a nil ruby version' do
        expect(project.ruby_version).to be_nil
      end
    end

    context 'with non-default initialization' do
      let(:project) { ProjectDirectories::Project.new(name: name, repo: repo) }
      let(:name) { 'my_project' }
      let(:repo) { 'git@github.com:mine/my_project.git'}

      it 'should have the correct name' do
        expect(project.name).to eq(name)
      end

      it 'should have the correct repo url' do
        expect(project.repo).to eq(repo)
      end

      describe '#working_dir' do
        subject(:working_dir) { project.working_dir }

        it 'should be a sibling to the vagrant directory' do
          expect(working_dir).to eq(File.expand_path("../#{name}", ProjectDirectories.vagrant_dir))
        end
      end

      describe '#ruby_version' do
        subject(:ruby_version) { project.ruby_version }
        let(:working_dir) { File.expand_path("../#{name}", ProjectDirectories.vagrant_dir) }
        before { FileUtils.mkdir_p(working_dir) }

        let(:version_string) { '2.1.5' }

        context 'when there is a .ruby-version file' do
          before do
            ruby_version_file = File.expand_path('.ruby-version', working_dir)
            File.open(ruby_version_file, 'w') { |f| f.write "#{version_string }\n" }
          end

          it 'should return the correct version string' do
            expect(ruby_version).to eq(version_string)
          end
        end

        context 'when there is a Gemfile' do
          let(:gemfile) { File.expand_path('Gemfile', working_dir) }

          context 'with a ruby version' do
            before do
              File.open(gemfile, 'w') do |f|
                f.write "source 'https://rubygems.org'\n"
                f.write "ruby '#{version_string}'\n\n"
                f.write "gem 'rails', '~> 4.1.7'\n"
              end
            end

            it 'should return the correct version string' do
              expect(ruby_version).to eq(version_string)
            end
          end

          context 'without a ruby version' do
            before do
              File.open(gemfile, 'w') do |f|
                f.write "source 'https://rubygems.org'\n\n"
                f.write "gem 'rails', '~> 4.1.7'\n"
              end
            end

            it 'should be nil' do
              expect(ruby_version).to be_nil
            end
          end
        end

        context 'when there is no ruby version specified' do
          it 'should be nil' do
            expect(ruby_version).to be_nil
          end
        end
      end
    end
  end
end
