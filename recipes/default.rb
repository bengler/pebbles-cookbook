#
# Cookbook Name:: pebbles
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Ruby Version Manager
node.set['rvm']['default_ruby'] = 'ruby-1.9.3-p392'
include_recipe "rvm::system"
include_recipe "rvm::vagrant"

# PostgreSQL
node.set['postgresql']['config'] = {
  'listen_addresses' => '*',
  'port' => 5432,
}
node.set['postgresql']['password'] = {
  'postgres' => 'md5795b9da941ed8f2fcd98998ec334d29d',
}
node.set['postgresql']['pg_hba'] = [
  { :type => 'host', :db => 'all', :user => 'all',
    :addr => '192.168.33.1/32', :method => 'md5' }
]
include_recipe "postgresql::server"
include_recipe "postgresql::client"

# Nginx
include_recipe "nginx"
