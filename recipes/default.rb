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

# HAProxy
node.set['haproxy']['incoming_port'] = 8080
node.set['haproxy']['member_port']   = 80
include_recipe "haproxy"

# Stop running Nginx and HAProxy services, Brow will start them
# with the correct configuration
execute "stop_nginx" do
  command "service nginx stop"
  only_if { ::File.exists?("/var/run/nginx.pid") }
end
execute "stop_haproxy" do
  command "service haproxy stop"
  only_if { ::File.exists?("/var/run/haproxy.pid") }
end

# Make vagrant user owner of /var/log/nginx
execute "nginx_logs_change_group_to_vagrant" do
  command "chown -R vagrant:vagrant /var/log/nginx"
  not_if { ::Etc.getpwuid(::File.stat('/var/log/nginx').uid).name == 'vagrant' }
end

# Install curl development packages
execute "install_curl_dev" do
  command "apt-get install -q -y libcurl4-openssl-dev"
  not_if { ::File.exists?("/usr/bin/curl-config") }
end

# Install screen
execute "install_screen" do
  command "apt-get install -q -y screen"
  not_if { ::File.exists?("/usr/bin/screen") }
end

# Brow is needed for pretty much anything
# include_recipe "pebbles::brow"
