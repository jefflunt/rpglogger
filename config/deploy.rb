require "bundler/capistrano"
require 'rvm/capistrano'

load "config/cap_recipes/cap_helpers"
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
set :rvm_install_with_sudo, true
set :rvm_ruby_string, 'ruby-1.9.2-p320'
set :rvm_type, :system

# Setup SSH stuff to things work as expected
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

# ------= Various deployment targets =------
# Production
desc "deploy to staging"
task :production do
  set :app_server, "rpglogger.com"
  set :rails_env, "production"
  set_roles
end

# Staging
desc "deploy to staging"
task :staging do
  set :app_server, "staging.rpglogger.com"
  set :rails_env, "staging"
  set_roles
end

# ------= Deploy tasks =------
namespace :deploy do
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
