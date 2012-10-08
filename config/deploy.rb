require "bundler/capistrano"
require 'rvm/capistrano'

load "config/cap_recipes/cap_helpers"
load "config/cap_recipes/env"
load "config/cap_recipes/apt"
load "config/cap_recipes/nginx"
load "config/cap_recipes/unicorn"

# App deploy setting and config options
set :application, "rpglogger"
set :user, "deployer"
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
end

# ------= Deploy the actual app =------
namespace :deploy do
  desc "Deploy a working app to a completely blank OS image"
  task :from_scratch do
    # ASSUMPTIONS:
    # Tested against Ubuntu 10.04 LTS, after the OS has been fully patched
    #   and the `build-essential` package as well as RVM + Ruby 1.9.2 have 
    #   been installed.
    
    install_package_prerequirements
    nginx.install
    setup
    cold
  end
  
  desc "Installs system packages required by the app"
  task :install_package_prerequirements do
    required_packages = ["libpq-dev"]
    
    required_packages.each do |package|
      run "#{sudo} apt-get -y install #{package}"
    end
  end
    
  task :setup_config, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
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
end
