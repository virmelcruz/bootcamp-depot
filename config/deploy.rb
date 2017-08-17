# config valid only for current version of Capistrano
lock '3.4.0' #version of capistrano
#primary true
#when server have load balancer
server '54.209.239.117', roles: [:web, :app, :db], primary: true #setup ip address of server with role web, app and db

#set = for setting variable in capstrano
set :repo_url,        'git@github.com:virmelcruz/bootcamp-depot.git' #repository url of github
set :application,     'depot' #application name
set :user,            'deploy' #our deploy user, user in server for ssh
set :puma_threads,    [4, 16] # provided by capistrano puma gem
set :puma_workers,    0       # provided by capistrano puma gem

# Don't change these unless you know what you're doing
set :pty,             true #means uses as terminal
set :use_sudo,        false
set :stage,           :production #rails environment to production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}" #destination folder when the app is deployed
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid" #stores the current process as temporary file
set :puma_access_log, "#{release_path}/log/puma.error.log" #logs of access
set :puma_error_log,  "#{release_path}/log/puma.access.log" #logs of errors
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) } #forward_agent: true = making pc/machine as the representative on getting the from the repo
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false  # Change to true if using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p" #where puma instance alive
      execute "mkdir #{shared_path}/tmp/pids -p" #where puma the process id stores
    end
  end

  before :start, :make_dirs #before start make directory
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master` #checks the version if the server and repo is the same version
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end