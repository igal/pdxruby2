#set :scm, "git"
#set :repository,  "git://github.com/igal/pdxruby2.git"
#set :branch, "master"
#set :deploy_via, :remote_cache

set :scm, :git
set :git_shallow_copy, 1
set :repository, '.'
set :deploy_via, :copy
set :copy_cache, true
set :copy_exclude, ['.git', 'log', 'tmp', '*.sql', '*.diff', 'coverage.info', 'coverage', 'public/images/members', 'public/system', 'tags', 'db/remote.sql', 'db/*.sqlite3', '*.swp', '.*.swp']
default_run_options[:pty] = true

set :deploy_to, "/var/www/pdxruby"
set :host, "dev.pragmaticraft.com"
set :user, "pdxruby"

role :app, host
role :web, host
role :db,  host, :master => true
