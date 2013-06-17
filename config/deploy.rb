#require 'rvm/capistrano'
require 'capistrano'
#set :rvm_type, :user
#set :rvm_ruby_string, 'ruby-2.0.0-p195@deploy_demo_app'
set :application, "Deploy Demo App"
set :repository,  "git://github.com/AlokAnand/deploy_demo_app.git"
set :scm, :git
set :scm_username, "AlokAnand"
set :branch, "master"
set :git_enable_submodules, 1
set :rails_env, "production"
default_environment["RAILS_ENV"] = 'production'
#set :rake , "/usr/bin/env/rake"
set :deploy_to, "/var/www/192.168.0.106"
set :deploy_via, :remote_cache
set :user, "alok"
set :use_sudo, false
set :ssh_options, { :forward_agent => true, :port => 22 }
set :keep_releases, 5
default_run_options[:pty] = true
set :ssh_options, { :forward_agent => true, :port => 22 }
set :keep_releases, 5
default_run_options[:pty] = true
role :web, "192.168.0.106"                          # Your HTTP server, Apache/etc
role :app, "192.168.0.106"                          # This may be the same as your `Web` server
role :db,  "192.168.0.106", :primary => true        # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Symlink shared config files"
  task :symlink_config_files do
    run "#{ sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  after "deploy", "rvm:trust_rvmrc"
  #  after "deploy:update_code", "deploy:migrate"
  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
    run "cd #{release_path}; RAILS_ENV=production rake db:create"
    run "cd #{release_path}; RAILS_ENV=production rake db:migrate"
  end

end

# if you want to clean up old releases on each deploy uncomment this:
after "deploy", "deploy:symlink_config_files"
after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"
