
execute "checkpoint_create_dbuser" do
  dbuser = 'checkpoint'
  user 'postgres'
  command %(createuser -d -s #{dbuser})
  not_if  %(psql -Atc 'select usename from pg_user' | grep -q #{dbuser}), :user => 'postgres'
end

execute "checkpoint_update_dbpass" do
  dbuser = 'checkpoint'
  dbpass = 'cp1234'
  user 'postgres'
  command %(psql -c "ALTER USER #{dbuser} WITH PASSWORD '#{dbpass}'")
end

[:development, :test].each do |environment|
  execute "checkpoint_createdb_#{environment}" do
    dbname = "checkpoint_#{environment}"
    dbuser = 'checkpoint'
    user 'postgres'
    command %(createdb -O #{dbuser} -E 'UTF8' -l 'en_US.UTF-8' -T 'template0' #{dbname})
    not_if  %(psql -l | grep -q #{dbname}), :user => 'postgres'
  end
end
