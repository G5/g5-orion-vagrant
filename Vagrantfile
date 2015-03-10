# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3001, host: 3001
  config.vm.network "forwarded_port", guest: 3002, host: 3002
  config.vm.network "forwarded_port", guest: 3003, host: 3003
  config.vm.network "forwarded_port", guest: 3004, host: 3004
  config.vm.network "forwarded_port", guest: 3005, host: 3005
  config.vm.network "forwarded_port", guest: 3006, host: 3006
  config.vm.network "forwarded_port", guest: 3007, host: 3007
  config.vm.network "forwarded_port", guest: 3008, host: 3008
  config.vm.network "forwarded_port", guest: 3009, host: 3009
  config.vm.network "forwarded_port", guest: 3010, host: 3010

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.30"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # If true, X11 forwarding over SSH connections is enabled. Defaults to false.
  config.ssh.forward_x11 = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  require_relative 'lib/project_directories'
  ruby_versions = Set.new
  ProjectDirectories.new.each do |name|
    source_dir = ProjectDirectories.working_dir(name)
    dest_dir = "/#{name}"

    if File.exists?(source_dir)
      config.vm.synced_folder(source_dir, dest_dir, nfs: true)

      ruby_ver = ProjectDirectories.ruby_version(name)
      ruby_versions << ruby_ver if ruby_ver
    else
      puts "I didn't find a directory for '#{name}'.  That might be OK, if you didn't need it."
    end
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = [ "g5stack", "cookbooks" ]
    chef.add_recipe "main"
    chef.json = {
      :postgresql => { :password => { :postgres => "password" } },
      :rbenv => { :ruby_versions => ruby_versions.to_a },
      :git => { :user => { :name => `git config user.name`.strip,
                           :email =>`git config user.email`.strip }},
      'g5-orion-vagrant' => { :env => {
                                :heroku_api_key => `echo $HEROKU_API_KEY`.strip,
                                :heroku_username => `echo $HEROKU_USERNAME`.strip,
                                :id_rsa => `echo $ID_RSA`.strip,
                                :heroku_repo => `echo $HEROKU_REPO`.strip,
                                :github_repo => `echo $GITHUB_REPO`.strip,
                                :aws_access_key_id => `echo $AWS_ACCESS_KEY_ID`.strip,
                                :aws_secret_access_key => `echo $AWS_SECRET_ACCESS_KEY`.strip,
                                :aws_region => `echo $AWS_REGION`.strip
                            }}
    }
end
