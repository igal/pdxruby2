# = Capistrano deployment
#
# To deploy the application using Capistrano, you must:
#
#  1. Install Capistrano and the multistage extension on your local machine:
#       sudo gem install capistrano capistrano-ext
#
#  2. Create or use a stage file as defined in the "config/deploy/" directory.
#     Read the other files in that directory for ideas. You will need to use
#     the name of your configuration in all remote calls. E.g., if you created
#     a "config/deploy/mysite.rb" (thus "mysite"), you will run commands like
#     "cap mysite deploy" to deploy using your "mysite" configuration.
#
#  3. Setup your server if this is the first time you're deploying, e.g.,:
#       cap mysite deploy:setup
#
#  4. Create the "shared/config/settings.yml" on your server. See the
#     "config/settings.yml.sample" file for details. If you try deploying to a
#     server without this file, you'll get instructions with the exact path to
#     put this file on the server.
#
#  5. Create the "shared/config/database.yml" on your server with the database
#     configuration. This file must contain absolute paths if you're using
#     SQLite. If you try deploying to a server without this file, you'll get
#     instructions with the exact path to put this file on the server.
#
#  6. Push your revision control changes and then deploy, e.g.,:
#       cap mysite deploy
#
#  7. If you have migrations that need to be applied, deploy with them, e.g.,:
#       cap mysite deploy:migrations
#
#  8. If you deployed a broken revision, you can rollback to the previous, e.g.,:
#       cap mysite deploy:rollback
ssh_options[:compression] = false

set :application, "pdxruby2"
set :use_sudo, false

# Load stages from config/deploy/*
set :stages, Dir["config/deploy/*.rb"].map{|t| File.basename(t, ".rb")}
require 'capistrano/ext/multistage'
set :default_stage, "pragmaticraft"

# :current_path - 'current' symlink pointing at current release
# :release_path - 'release' directory being deployed
# :shared_path - 'shared' directory with shared content

namespace :deploy do
  desc "Restart Passenger application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t.inspect} task is a no-op with Passenger"
    task t, :roles => :app do
      # Do nothing
    end
  end

  desc "Prepare shared directories"
  task :prepare_shared do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/db"
  end

  desc "Symlink the application's settings"
  task :link_settings_yml do
    source = "#{shared_path}/config/settings.yml"
    target = "#{release_path}/config/settings.yml"
    begin
      run %{if test ! -f #{source}; then exit 1; fi}
      run %{ln -nsf #{source} #{target}}
    rescue Exception => e
      puts <<-HERE
ERROR!  You must have a file on your server with configuration information.
        See the "config/settings.yml.sample" file for details on this.
        You will need to upload your completed file to your server at:
            #{source}
      HERE
      raise e
    end
  end

  desc "Symlink the database settings"
  task :link_database_yml do
    source = "#{shared_path}/config/database.yml"
    target = "#{release_path}/config/database.yml"
    begin
      run %{if test ! -f #{source}; then exit 1; fi}
      run %{ln -nsf #{source} #{target}}
    rescue Exception => e
      puts <<-HERE
ERROR!  You must have a file on your server with the database configuration.
        This file must contain absolute paths if you're using SQLite.
        You will need to upload your completed file to your server at:
            #{source}
      HERE
      raise e
    end
  end

  desc "Link the member images"
  task :link_member_images do
    source = "#{shared_path}/system/member_images"
    target = "#{release_path}/public/images/members"

    run %{if test ! -f #{source}; then mkdir -p #{source}; fi}
    run %{mv #{target} #{target}.bak}
    run %{ln -nsf #{source} #{target}}
  end

  desc "Clear the application's cache"
  task :clear_cache do
    run "(cd #{current_path} && rake RAILS_ENV=production clear)"
  end
end

desc "Upload member images"
task :upload_member_images do
  source = "#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/public/images/members/"
  target = "#{shared_path}/system/member_images/"
  system "(cd #{source} && rsync -uvax . #{user}@#{host}:#{target})"
end

desc "Download member images"
task :download_member_images do
  target = "#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/public/images/members/"
  source = "#{shared_path}/system/member_images/"
  system "(cd #{target} && rsync -uvax #{user}@#{host}:#{source} .)"
end

# After setup
after "deploy:setup", "deploy:prepare_shared"

# After finalize_update
before "deploy:finalize_update", "deploy:link_database_yml"
before "deploy:finalize_update", "deploy:link_settings_yml"
before "deploy:finalize_update", "deploy:link_member_images"

# After symlink
after "deploy:symlink", "deploy:clear_cache"
