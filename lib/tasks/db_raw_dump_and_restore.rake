namespace :db do
  # Load Shellwords::shellescape from the system, else use a stashed copy for use with older Ruby interpreters.
  require 'shellwords'
  require 'lib/shellwords' unless defined?(Shellwords.shellescape)
  include Shellwords

  # Return string with MySQL credentials for use on a command-line.
  def mysql_credentials_for(struct)
    string = ""
    string << "--user #{struct.username.shellescape}" if struct.username
    string << "--password #{struct.password.shellescape}" if struct.password
    string << "--host #{struct.host.shellescape}" if struct.host
    string << "#{struct.database.shellescape}"
    return string
  end

  # Return string with PostgreSQL credentials for use on a command-line.
  def postgresql_credentials_for(struct)
    string = "#{struct.database.shellescape}"
    string << "-U #{struct.username.shellescape}" if struct.username
    string << "-h #{struct.host.shellescape}" if struct.host
    string << "-p #{struct.port.shellescape}" if struct.port
    return string
  end

  namespace :raw do
    desc 'Dump database to FILE or name of RAILS_ENV'
    task :dump do
      verbose(true) unless Rake.application.options.silent

      require 'lib/database_yml_reader'
      struct = DatabaseYmlReader.read
      target = ENV['FILE'] || "#{File.basename(Dir.pwd)}.sql"
      target_tmp = "#{target}.tmp"
      adapter = struct.adapter

      case adapter
      when 'sqlite3'
        source = struct.database
        sh "sqlite3 #{shellescape source} .dump > #{shellescape target}"
      when 'mysql'
        sh "mysqldump --add-locks --create-options --disable-keys --extended-insert --quick --set-charset #{mysql_credentials_for struct} > #{shellescape target_tmp}"
        mv target_tmp, target
      when 'postgresql'
        sh "pg_dump #{postgresql_credentials_for struct} --clean --no-owner --no-privileges --file #{shellescape target_tmp}"
        mv target_tmp, target
      else
        raise ArgumentError, "Unknown database adapter: #{adapter}"
      end
    end

    desc 'Restore database from FILE'
    task :restore do
      verbose(true) unless Rake.application.options.silent

      source = ENV['FILE']
      raise ArgumentError, 'No FILE argument specified to restore from' unless source

      require 'lib/database_yml_reader'
      struct = DatabaseYmlReader.read
      adapter = struct.adapter

      case adapter
      when 'sqlite3'
        target = struct.database
        mv target, "#{target}.old" if File.exist?(target)
        sh "sqlite3 #{shellescape target} < #{shellescape source}"
      when 'mysql'
        sh "mysql #{mysql_credentials_for struct} < #{shellescape source}"
      when 'postgresql'
        sh "psql #{postgresql_credentials_for struct} < #{shellescape source}"
      else
        raise ArgumentError, "Unknown database adapter: #{adapter}"
      end

      Rake::Task['clear'].invoke
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
      user_at_host = "#{c.username}@#{c.hostname}"
      sh 'ssh', user_at_host, c.backup_command
      sh 'rsync', '-uvax', '--progress', "#{user_at_host}:#{c.backup_file}", backup_file
    end

    desc 'Restore a copy of the remote database locally'
    task :restore_locally do
      backup_file = File.join(RAILS_ROOT, 'db', 'remote.sql')
      ENV['FILE'] = backup_file
      Rake::Task['db:raw:restore'].invoke
    end
  end
end
