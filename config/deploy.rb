require 'capistrano'
set :application, "Deploy Demo App"
set :repository,  "git://github.com/AlokAnand/deploy_demo_app.git"
set :scm, :git
set :scm_username, "AlokAnand"
set :branch, "master"
set :git_enable_submodules, 1
set :rails_env, "production"
set :deploy_to, "/var/www/192.168.0.106"
set :deploy_via, :remote_cache
set :user, "alok"
set :group, "deployers"
set :use_sudo, false
set :ssh_options, { :forward_agent => true, :port => 22 }
set :keep_releases, 5
default_run_options[:pty] = true
role :web, "192.168.0.106"                          # Your HTTP server, Apache/etc
role :app, "192.168.0.106"                          # This may be the same as your `Web` server
role :db,  "192.168.0.106", :primary => true        # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after 'deploy:update_code', 'deploy:symlink_config_files'
after "deploy:restart", "deploy:cleanup" 

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Symlink shared config files"
  task :symlink_config_files do
    run "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
    run "cd #{release_path}; RAILS_ENV=production rake db:create"
    run "cd #{release_path}; RAILS_ENV=production rake db:migrate"
  end

end
