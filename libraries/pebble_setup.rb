require 'fileutils'

module PebbleSetup

  def pebble_name(name)
    @pebble = name
  end

  def pebble
    @pebble or raise "Pebble recipe has not set pebble_name!"
  end

  # Path to where code repositories are located
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

  def root_path
    File.join(repositories, pebble)
  end

  # Install bundle
  def bundle_install
    path = root_path
    execute "Installing bundle" do
      command %(su vagrant -lc "cd #{path} && bundle install")
    end
  end

  # Run a rake task
  def rake_task(task_name, options = {})
    environment = options[:env] || :development
    rake_command = "bundle exec rake #{task_name} RACK_ENV=#{environment}"
    path = root_path
    execute "Running rake task #{task_name}" do
      command %(su vagrant -lc "cd #{path} && #{rake_command}")
    end
  end

  # Create log directory if it doesn't exist
  def ensure_log_directory
    FileUtils.mkdir_p File.join(root_path, 'log')
  end

  # Create symlink to code in ~/.brow
  def brow_symlink
    path = root_path
    execute "Creating symlink in ~/.brow" do
      command %(su vagrant -lc "mkdir -p ~/.brow && cd ~/.brow && ln -s #{path}")
    end
  end

  # Setup databases and database users
  def database_setup
    config_tmpl = File.join(root_path, 'config', 'database-example.yml')
    config_file = File.join(root_path, 'config', 'database.yml')

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
end
