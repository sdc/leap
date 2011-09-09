set :application, "ilp2"
set :repository,  "git@github.com:sdc/leap.git"
set :deploy_to, "/srv/#{application}"
default_run_options[:pty] = true

set :scm, :git
set :branch, "sdc_stable"

role :web, "172.20.1.42"                 
role :app, "172.20.1.42"                  
role :db,  "172.20.1.42", :primary => true 

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :after_deploy do
    #run "rm #{current_path}/config/database.yml"
    run "ln -s #{shared_path}/database.yml #{current_path}/config/database.yml"
    run "ln -s #{shared_path}/error_mail.rb #{current_path}/config/initializers/error_mail.rb"
    run "ln -s /media/photos #{current_path}/public/photos"
  end
end
