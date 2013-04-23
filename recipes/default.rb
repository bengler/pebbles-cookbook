#
# Cookbook Name:: pebbles
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Ubuntu packages
include_recipe "pebbles::packages"

# Ruby through RVM
include_recipe "pebbles::ruby"

# PostgreSQL
include_recipe "pebbles::postgresql"

# Brow
include_recipe "pebbles::brow"
