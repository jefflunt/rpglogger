require "bundler/capistrano"
require 'rvm/capistrano'

load "config/cap_recipes/cap_helpers"
load "config/cap_recipes/apt"
load "config/cap_recipes/nginx"
load "config/cap_recipes/unicorn"
load "config/cap_recipes/rvm"
load "config/cap_recipes/s3ql"

# App deploy setting and config options
set :application, "rpglogger"
set :user, "ubuntu"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache

# sudo and permissions
set :use_sudo, false
set :rvm_ruby_string, 'ruby-1.9.2-p320'

# Setup SSH connection options
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "kn-aws-servers.pem")]
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Deploy branch/SCM options
set :scm, "git"
set :repository, "git@github.com:normalocity/#{application}.git"
set :branch do
  puts
  puts "Tags: " + `git tag`.split("\n").join(", ")
  puts "Remember to push tags first: git push origin --tags"
  ref = Capistrano::CLI.ui.ask "Tag, branch, or commit to deploy [master]: "
  ref.empty? ? "master" : ref
end
after "deploy", "deploy:cleanup" # keep only the last 5 releases

# App roles
task :set_roles do
  role :app, app_server, :primary => true
  role :web, app_server, :primary => true
  role :db, app_server, :primary => true
end

# Deploy environments
desc "Set production settings"
task :production do
  set :app_server, "rpglogger.com"
  set :rails_env, "production"
  set :server_name_for_config, app_server
  set_roles
end

desc "Set staging settings"
task :staging do
  set :app_server, "staging.rpglogger.com"
  set :rails_env, "production"  # It's intentional that this also says "production" - we want staging and production to be
                                # basically identical, except for the server URL to which they're deployed.
  set :server_name_for_config, app_server
  set_roles
end

desc "Promotes the staging server into a production server"
task :promote do
  set :app_server, "staging.rpglogger.com"
  set :rails_env, "production"
  set :server_name_for_config, "rpglogger.com"
  
  nginx_unicorn.regenerate_config
  unicorn.regenerate_config
  s3ql.regenerate_config
  
  puts ""
  puts "====> NEXT STEPS ======================================================"
  puts "1. Change the EC2 labels"
  puts "2. Update where the database points to"
  puts "3. Restart the server"
  puts "4. Re-point the production IP address"
  puts "5. Do something for good luck."
end

desc "Reboots the entire server, not just the app"
task :reboot_full_server do
  run "#{sudo} shutdown -r now"
end

# ------= Deploy the actual app =------
namespace :deploy do
  # To setup app on new server (these are all one-time run tasks):
  # cap [env] deploy:bootstrap    <== Runs the bootstrap script, getting basics setup
  # cap [env] deploy:install      <== Installs app version of Ruby, package dependencies
  # cap [env] deploy:setup        <== Sets up magic app links, folders, etc.
  # cap [env] deploy:cold         <== Initial deploy of the actual application
  
  desc "Bootstraps the server with basic software dependency needs."
  task :bootstrap do
    run "curl https://raw.github.com/normalocity/rpglogger/#{branch}/config/bootstrap_server.sh | bash -s"
  end
  
  desc "Install application dependencies and web server."
  task :install do
    install_app_package_dependencies
    nginx.install
    s3ql.install
  end
    
  desc "Installs system packages required by the app"
  task :install_app_package_dependencies, roles: :app do
    required_packages = ["libxml2",           # Required by `nokogiri` gem
                         "libxslt-dev",       # Required by `nokogiri` gem
                         "libxml2-dev",       # Required by `nokogiri` gem
                         "libpq-dev",         # Required by `pg` gem
                         "libmagickwand-dev"] # Required by `rmagick` gem as part of native ImageMagick
    required_packages.each do |package|
      run "#{sudo} apt-get -y install #{package}"
    end
  end
    
  task :setup_config, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.example.yml"
    
    puts ""
    puts "====> NEXT STEPS ========================================================================================"
    puts "1. Edit the database.yml in #{shared_path}/config"
    puts "2. Run the 'mkfs.s3ql s3://[app_server].rpglogger.com --plain'"
    puts "    (if the FS alredy exists, that's fine - it'll fail gracefully)"
    puts "3. Reboot and check that the auto-mount works as expected"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs /mnt/s3/#{application} #{release_path}/public/uploads"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, :roles => :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
  
  %w[start stop].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
  
  # Because of some unicorn configuration we have, a restart has to be
  # a full stop and start in order to work
  desc "Restart unicorn"
  task :restart, roles: :app do
    stop
    start
  end
end
