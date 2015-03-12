# G5 Orion Vagrant

Everything you need for development work on the Orion stack.

## Current Version ##

0.1.0

## Requirements ##

* [Vagrant](http://vagrantup.com) >= 1.5
* [Oracle VirtualBox](http://virtualbox.org)
* [ChefDK](https://downloads.getchef.com/chef-dk) >= 0.4.0
* [Ruby](https://www.ruby-lang.org) >= 1.9.3
* [XQuartz](http://xquartz.macosforge.org/trac/wiki/Releases) (if using Mac OS X)

## Installation ##

1. Clone the vagrant project:

   ```console
   $ git clone git@github.com:G5/g5-orion-vagrant.git
   $ cd g5-orion-vagrant
   ```

2. Execute the setup script:

   ```console
   $ ./bin/setup.rb
   ```
**NOTE:** the vagrant-berkshelf plugin requires the version of Berkshelf
distributed with ChefDK, *not* the berkshelf gem. If you previously installed
berkshelf as a stand-alone gem, you will receive a warning while running the
setup script, and errors when you run `vagrant up`. In order to use this
project, you can either uninstall the berkshelf gem, or you can run all
Vagrant commands through chef exec (e.g. `chef exec vagrant up`).

## Usage ##

### Managing Vagrant ###

To start up the Vagrant VM:

```console
$ vagrant up
```

To SSH to the Vagrant VM:

```console
$ vagrant ssh
```

To suspend/resume a Vagrant VM:

```console
$ vagrant suspend
$ vagrant resume
```

To destroy the Vagrant VM (it will be rebuilt the next
time `vagrant up` is executed):

```console
$ vagrant destroy
```

For more information, see the [Vagrant documentation](http://docs.vagrantup.com/v2/).

### Development in Vagrant ###

The github repos listed in `projects.yml` (or `projects-override.yml`)
will be mounted under the root directory (`/`) in the VM.

```console
$ ls -l /
...
drwxr-xr-x 28     502 dialout   952 Mar 11 00:48 g5-client-app-creator
drwxr-xr-x 28     502 dialout   952 Mar 11 00:48 g5-configurator
drwxr-xr-x 32     502 dialout  1088 Mar  9 19:15 g5-content-management-system
drwxr-xr-x 35     502 dialout  1190 Mar 11 00:42 g5-hub
drwxr-xr-x 25     502 dialout   850 Mar 11 00:48 g5-layout-garden
drwxr-xr-x 25     502 dialout   850 Mar 11 00:48 g5-phone-number-service
drwxr-xr-x 23     502 dialout   782 Mar 11 00:48 g5-pricing-and-availability-service
drwxr-xr-x 28     502 dialout   952 Mar 11 00:48 g5-sibling-deployer
drwxr-xr-x 24     502 dialout   816 Mar 11 00:48 g5-theme-garden
drwxr-xr-x 31     502 dialout  1054 Mar 11 00:48 g5-widget-garden
...
```

The code for the Vagrant project itself (this repository) will be mounted
at `/vagrant`.

All non-gem prerequisites (e.g. postgresql) are installed by Chef during the
provisioning process, but you'll still have to perform the db setup and install
gems for each project yourself. Postgresql is already set up with a user named
'vagrant' (no password). For example:

```console
$ cd /g5-hub
$ gem install bundler
$ bundle install
$ cp config/database.yml.example config/database.yml
# Edit the database.yml for the vagrant user
$ bundle exec rake db:setup
```

Each project contains more specific documentation on how to set up your
development environment.

## Authors ##

* Maeve Revels / [@maeve](https://github.com/maeve)
* Jessica Suttles / [@jlsuttles](https://github.com/jlsuttles)

## Contributions ##

1. Fork it
2. Set up your [cookbook development environment](#cookbook-development-setup)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Update cookbook implementation as needed.
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new pull request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/G5/g5-orion-vagrant/issues).

### Cookbook Development Setup ###

1. Clone the repository locally:

  ```console
  $ git clone git@github.com:G5/g5-orion-vagrant.git
  $ cd g5stack
  ```

2. Install required cookbooks using [Berkshelf](http://berkshelf.com/):

  ```console
  $ chef exec berks install
  ```

3. Provision an instance for development using [test-kitchen](http://kitchen.ci):

  ```console
  $ chef exec kitchen converge
  ```

  See `chef exec kitchen help` for more test-kitchen commands.

### Specs ###

The unit tests use [ChefSpec](http://sethvargo.github.io/chefspec/),
and live in the `test/unit` directory. To execute the unit tests:

```console
$ chef exec rspec
```

To run the [foodcritic](http://acrmp.github.io/foodcritic) linting tool:

```console
$ chef exec foodcritic .
```

The integration tests use [ServerSpec](http://serverspec.org), and live
in the `test/integration/default/serverspec` directory. To execute
the test suite without re-provisioning:

```console
$ chef exec kitchen verify
```

To execute the full integration test run (environment setup and convergence,
test verification, and environment teardown):

```console
$ chef exec kitchen test
```

### Releasing ###

1. Update the version in the [README](#current-version) and
   [CHANGELOG](./CHANGELOG.md), and [metadata.rb](./metadata.rb), following
   the guidelines of [semantic versioning](http://semver.org).

2. Tag the code with the latest version:

   ```console
   $ git tag -a v0.1.0 -m "Use g5stack base box"
   $ git push --tags
   ```

## License ##

Copyright (c) 2014 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
