$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "bundler/capistrano"
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.2-p320'
set :rvm_type, :system

set :application, "rpglogger"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "kn-aws-servers.pem")]
ssh_options[:forward_agent] = true

set :scm, "git"
set :repository, "git@github.com:normalocity/#{application}.git"
set :branch do
  puts
  puts "Tags: " + `git tag`.split("\n").join(", ")
  puts "Remember to push tags first: git push origin --tags"
  ref = Capistrano::CLI.ui.ask "Tag, branch, or commit to deploy [master]: "
  ref.empty? ? "master" : ref
end

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

task :set_roles do
  role :app, app_server, :primary => true
  role :web, app_server, :primary => true
#  role :db, app_server, :primary => true
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
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, :roles => :app, :except => {:no_release => true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, :roles => :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init_#{rails_env}.sh /etc/init.d/unicorn_#{application}"
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
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end
after "deploy:update_code", "rvm:trust_rvmrc"

