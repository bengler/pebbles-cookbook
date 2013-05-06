#
# Cookbook Name:: pebbles
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

class Chef::Recipe
  include PebbleSetup
end

# Ubuntu packages
include_recipe "pebbles::packages"

# System setup
include_recipe "pebbles::system"

# Ruby through RVM
include_recipe "pebbles::ruby"

# PostgreSQL
include_recipe "pebbles::postgresql"

# Brow
include_recipe "pebbles::brow"
