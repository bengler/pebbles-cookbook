pebble_name "checkpoint"

database_setup

bundle_install

rake_task "db:migrate"
rake_task "db:migrate", :env => :test

ensure_log_directory

brow_symlink
