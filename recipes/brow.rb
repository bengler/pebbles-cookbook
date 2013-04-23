# Brow handles pebbles haproxy/nginx configuration

# HAProxy
node.set['haproxy']['incoming_port'] = 8080
node.set['haproxy']['member_port']   = 80
include_recipe "haproxy"

# Nginx
include_recipe "nginx"

# Let Brow handle nginx and haproxy services
['nginx', 'haproxy'].each do |service_name|
  service(service_name) do
    action [:disable, :stop]
    not_if { ::File.exists?("/tmp/brow/#{service_name}.pid") }
  end
end

# Make vagrant user owner of /var/log/nginx
execute "nginx_logs_change_group_to_vagrant" do
  command "chown -R vagrant:vagrant /var/log/nginx"
  not_if { ::Etc.getpwuid(::File.stat('/var/log/nginx').uid).name == 'vagrant' }
end
