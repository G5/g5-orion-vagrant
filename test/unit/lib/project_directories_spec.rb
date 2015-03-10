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
        expect(project_entries).to include('my-custom-project' => 'my-repo-url')
      end

      it 'should have an entry for the second custom project' do
        expect(project_entries).to include('my-other-custom-project' => 'my-other-repo-url')
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
        expect(project_entries).to include('main-app' => 'repo.url')
      end

      it 'should have an entry for the second custom project' do
        expect(project_entries).to include('auxiliary_gem_project' => 'gem.repo.url')
      end
    end

    context 'without a projects file' do
      it 'should have no projects' do
        expect(project_entries).to be_empty
      end
    end
  end

  describe '#each' do
    before do
      File.open('projects-override.yml', 'w') { |f| f.write overrides.to_yaml }
      File.open('projects.yml', 'w') { |f| f.write projects.to_yaml }
    end

    let(:mock_obj) { double(set_project: nil) }

    context 'without arguments' do
      let(:projects_each) { ProjectDirectories.new.each }

      it 'should return an enumerator' do
        expect(projects_each).to be_an_instance_of(Enumerator)
      end

      it 'should enumerate the overrides hash pairs' do
        expect(projects_each.inspect).to eq(overrides.each_pair.inspect)
      end

      it 'should not use the default projects hash' do
        expect(projects_each.inspect).to_not eq(projects.each_pair.inspect)
      end

      it 'should not be empty' do
        expect { projects_each.next }.to_not raise_error
      end
    end

    context 'with block that accepts one argument' do
      let!(:projects_each) do
        ProjectDirectories.new.each do |proj_name|
          mock_obj.set_project(proj_name)
        end
      end

      it 'should call the block twice' do
        expect(mock_obj).to have_received(:set_project).twice
      end

      it 'should call the block with the first project name' do
        expect(mock_obj).to have_received(:set_project).with(overrides.keys.first)
      end

      it 'should call the block with the second project name' do
        expect(mock_obj).to have_received(:set_project).with(overrides.keys.last)
      end
    end

    context 'with block that accepts two arguments' do
      let!(:projects_each) do
        ProjectDirectories.new.each do |proj_name, repo_url|
          mock_obj.set_project(proj_name, repo_url)
        end
      end

      it 'should call the block twice' do
        expect(mock_obj).to have_received(:set_project).twice
      end

      it 'should call the block with the first project entry' do
        expect(mock_obj).to have_received(:set_project).
          with(overrides.keys.first, overrides.values.first)
      end

      it 'should call the block the second project entry' do
        expect(mock_obj).to have_received(:set_project).
          with(overrides.keys.last, overrides.values.last)
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

  describe '.working_dir' do
    let(:working_dir) { ProjectDirectories.working_dir('foo') }

    it 'should be a sibling to the vagrant directory' do
      expect(working_dir).to eq(File.expand_path('../foo',ProjectDirectories.vagrant_dir))
    end
  end

  describe '.ruby_version' do
    subject(:ruby_version) { ProjectDirectories.ruby_version('foo') }
    let(:working_dir) { File.expand_path('../foo', ProjectDirectories.vagrant_dir) }
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
