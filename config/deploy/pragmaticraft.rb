set :scm, "git"
set :repository,  "git://github.com/igal/pdxruby2.git"
set :branch, "master"
set :deploy_to, "/var/www/pdxruby"
set :host, "dev.pragmaticraft.com"
set :user, "pdxruby"

set :deploy_via, :remote_cache
role :app, host
role :web, host
role :db,  host, :primary => true
default_run_options[:pty] = true
