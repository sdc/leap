require 'bundler/capistrano'
load 'deploy/assets'
set :application, "ilp2"
set :deploy_to, "/srv/#{application}"
set :repository,  "git://github.com/sdc/leap.git"
set :scm, :git
set :use_sudo, false
set :branch, "beta"
default_run_options[:pty] = true

role :web, "172.20.11.41"
role :app, "172.20.11.41"
role :db,  "172.20.11.41"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "db:db_config"
