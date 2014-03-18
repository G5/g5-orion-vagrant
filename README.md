# G5 Orion Vagrant

Everything you need for development work on the Orion stack.

## Prerequisites

- [Oracle VirtualBox][virtualbox]
- [Vagrant][vagrant]

[virtualbox]: https://www.virtualbox.org/
[vagrant]: http://www.vagrantup.com/

## Setup

### Automagical Method

Execute the following command:

```bash
./bin/setup.rb
```

### Manual Method

Initialize git submodules that contain shared recipes:

```bash
git submodule update --init --recursive
```

Clone the development repositories as siblings of the g5-orion-vagrant working
directory. For example:

```bash
cd ..
git clone git@github.com:G5/g5-hub.git
git clone git@github.com:G5/g5-configurator.git
```

By default, the local working directories for the development repos are assumed
to have the names listed in `projects.yml`.  If you have altered the
directory names locally, or wish to load additional shared directories, you
can do so in `projects-override.yml`:

```bash
cp projects.yml projects-override.yml
# Edit project names in projects-override.yml
```

In order to use ssh-agent forwarding to share your local machine's ssh keys
(which will allow you to do things like git push/pull from within the VM),
execute the following on your host machine:

```bash
ssh-add
```

## Usage Examples ##

To start up the vagrant VM:

```bash
vagrant up
```

To SSH to the vagrant VM:

```bash
vagrant ssh
```

The development projects listed in `projects.yml` (or `projects-override.yml`)
will be mounted under the root directory (`/`) in the VM. Also, port
forwarding has been configured to map port 5000 on the host to port 3000
in the VM. For example:

```bash
vagrant ssh
cd /g5-hub
rails server
# The g5-hub service is now available at localhost:5000 on the host machine
```

To suspend/resume a vagrant VM:

```bash
vagrant suspend
vagrant resume
```

To destroy the vagrant VM (it will be rebuilt the next
time `vagrant up` is executed):

```bash
vagrant destroy
```
For more information, see the [Vagrant documentation][vagrant-docs].

[vagrant-docs]: http://docs.vagrantup.com/
