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
to have the names listed in `projects.yml`.
