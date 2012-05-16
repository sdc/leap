require 'bundler/capistrano'
load 'deploy/assets'
set :application, "leap"
set :deploy_to, "/var/www/#{application}"
set :repository,  "git://github.com/sdc/leap.git"
set :local_repository,  "https://kevtufc@github.com/sdc/leap.git"
set :scm, :git
set :use_sudo, false
default_run_options[:pty] = true

set :branch, "Swindon"
role :app, "eilp.swindon-college.ac.uk"
role :web, "eilp.swindon-college.ac.uk"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "ln -s /media/photos/Images #{current_path}/public/photos"
  end
end

namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "db:db_config"
