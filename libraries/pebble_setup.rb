module PebbleSetup

  def repositories
    repos = node['pebbles']['repositories']
    if !repos
      Chef::Log.fatal("Required attribute node['pebbles']['repositories'] not set!")
      raise
    end
    if !(File.directory?(repos))
      Chef::Log.fatal("Attribute node['pebbles']['repositories'] does not point to an existing directory: #{repos}")
      raise
    end
    repos
  end

  def bundle_install
    path = File.join(repositories, pebble_name)
    execute "Installing bundle" do
      command %(su vagrant -lc "cd #{path} && bundle install")
    end
  end

  def database_setup
    config_tmpl = File.join(repositories, pebble_name, 'config', 'database-example.yml')
    config_file = File.join(repositories, pebble_name, 'config', 'database.yml')

    if !File.exists?(config_file)
      if File.exists?(config_tmpl)
        Chef::Log.fatal("[#{pebble_name}] Database config template exists, but no actual config.")
        raise
      else
        return
      end
    end

    configs = YAML.load(File.read(config_file))

    ['development', 'test'].each do |environment|
      config = configs[environment] or next

      dbuser = config['username']
      dbname = config['database']

      execute "Create database user for #{environment}" do
        user 'postgres'
        command %(createuser -d -s #{dbuser})
        not_if  %(psql -Atc 'select usename from pg_user' | grep -q #{dbuser}), :user => 'postgres'
      end

      execute "Update database password for user #{dbuser}" do
        user 'postgres'
        command %(psql -c "ALTER USER #{dbuser} WITH PASSWORD '#{config['password']}'")
      end

      execute "Create database for #{environment}" do
        user 'postgres'
        command %(createdb -O #{dbuser} -E 'UTF8' -l 'en_US.utf8' -T 'template0' #{dbname})
        not_if  %(psql -l | grep -q #{dbname}), :user => 'postgres'
      end
    end
  end

  # Deduce pebble name from calling recipe
  def pebble_name
    File.basename caller[1].split(':')[0], '.rb'
  end

end
