#
# Cookbook Name:: g5-orion-vagrant
# Spec:: default
#
# Copyright (c) 2015 G5, All Rights Reserved.

require 'spec_helper'

describe 'g5-orion-vagrant::default' do

  context 'When all attributes are default, on an unspecified platform' do

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

  end
end