include_recipe "pebbles::checkpoint"

pebble_name "grove"

database_setup

bundle_install

rake_task "db:migrate"
rake_task "db:migrate", :env => :test
