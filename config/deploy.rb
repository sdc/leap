require 'bundler/capistrano'
load 'deploy/assets'
set :application, "leap"
set :deploy_to, "/srv/#{application}"
set :repository,  "http://github.com/sdc/leap.git"
set :scm, :git
set :branch, "cymoedd"
set :use_sudo, false
default_run_options[:pty] = true

role :app, "leap.cymoedd.ac.uk"
role :web, "leap.cymoedd.ac.uk"

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
