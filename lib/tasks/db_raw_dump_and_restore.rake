namespace :db do
  def mysql_credentials_for(struct)
    string = "--user='#{struct.username}' --password='#{struct.password}' '#{struct.database}'"
    string << " --host='#{struct.host}'" if struct.host
    return string
  end

  def postgresql_credentials_for(struct)
    string = "#{struct.database}"
    string << " -U '#{struct.username}'" if struct.username
    string << " -h '#{struct.host}'" if struct.host
    string << " -p '#{struct.port}'" if struct.port
    return string
  end

  namespace :raw do
    desc "Dump database to FILE or name of RAILS_ENV"
    task :dump do
      verbose(true) unless Rake.application.options.silent

      require "lib/database_yml_reader"
      struct = DatabaseYmlReader.read
      target = ENV['FILE'] || "#{File.basename(Dir.pwd)}.sql"
      adapter = struct.adapter

      case adapter
      when "sqlite3"
        source = struct.database
        sh "sqlite3 #{source} '.dump' > #{target}"
      when "mysql"
        sh "mysqldump --add-locks --create-options --disable-keys --extended-insert --quick --set-charset #{mysql_credentials_for(struct)} > #{target}.tmp && mv #{target}.tmp #{target}"
      when "postgresql"
        sh "pg_dump #{postgresql_credentials_for(struct)} --clean --no-owner --no-privileges --file #{target}.tmp && mv #{target}.tmp #{target}"
      else
        raise ArgumentError, "Unknown database adapter: #{adapter}"
      end
    end

    desc "Restore database from FILE"
    task :restore do
      verbose(true) unless Rake.application.options.silent

      source = ENV['FILE']
      raise ArgumentError, "No FILE argument specified to restore from." unless source

      require "lib/database_yml_reader"
      struct = DatabaseYmlReader.read
      adapter = struct.adapter

      case adapter
      when "sqlite3"
        target = struct.database
        mv target, "#{target}.old" if File.exist?(target)
        sh "sqlite3 #{target} < #{source}"
      when "mysql"
        sh "mysql #{mysql_credentials_for(struct)} < #{source}"
      when "postgresql"
        sh "psql #{postgresql_credentials_for(struct)} < #{source}"
      else
        raise ArgumentError, "Unknown database adapter: #{adapter}"
      end

      Rake::Task["clear"].invoke
    end
  end

  namespace :remote do
    desc 'Use remote database -- download and restore it locally'
    task :use => [:download, :restore_locally]

    desc 'Generate and download database backup from remote server'
    task :download do
      require 'erb'
      require 'yaml'
      require 'ostruct'
      backup_file = ENV['FILE'] || File.join(RAILS_ROOT, 'db', 'remote.sql')
      config_file = File.join(RAILS_ROOT, 'config', 'db_remote.yml')
      sample_file = File.join(RAILS_ROOT, 'config', 'db_remote~sample.yml')
      unless File.exist?(config_file)
        puts %{ERROR: Can't find configuration at '#{config_file}', see #{sample_file} for sample.}
        exit 1
      end
      c = OpenStruct.new(YAML.load(ERB.new(File.read(config_file)).result))
      mkdir_p File.dirname(backup_file)
      sh 'ssh', "#{c.username}@#{c.hostname}", c.backup_command
      sh 'rsync', '-uvax', '--progress', "#{c.username}@#{c.hostname}:#{c.backup_file}", backup_file
    end

    desc 'Restore a copy of the remote database locally'
    task :restore_locally do
      backup_file = File.join(RAILS_ROOT, 'db', 'remote.sql')
      ENV['FILE'] = backup_file
      Rake::Task['db:raw:restore'].invoke
    end
  end
end
