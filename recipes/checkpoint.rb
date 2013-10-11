pebble_name "checkpoint"

database_setup

bundle_install

rake_task "db:migrate"
rake_task "db:migrate", :env => :test

bundle_exec './bin/checkpoint realm create amedia -t \'Amedia Security Realm\' -d amedia.no'

ensure_log_directory

brow_symlink
