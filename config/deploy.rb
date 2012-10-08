require "bundler/capistrano"
require 'rvm/capistrano'

load "config/cap_recipes/cap_helpers"
load "config/cap_recipes/apt"
load "config/cap_recipes/nginx"
load "config/cap_recipes/unicorn"
load "config/cap_recipes/rvm"

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
  role :db, app_server, :primary => true
end

# Deploy environments
desc "Set production settings"
task :production do
  set :app_server, "rpglogger.com"
  set :rails_env, "production"
  set_roles
end

desc "Set staging settings"
task :staging do
  set :app_server, "staging.rpglogger.com"
  set :rails_env, "production"  # It's intentional that this also says "production" - we want staging and production to be
                                # basically identical, except for the server URL to which they're deployed.
  set_roles
end

# ------= Deploy the actual app =------
namespace :deploy do
  # ASSUMPTIONS when deploying this app:
  # Ubuntu 10.04 LTS
  # User `deployer` has been created, is a sudoer, and has SSH `authorized_keys` setup
  # OS has been fully patched (i.e. `apt-get update` and `apt-get upgrade`)
  # Install package dependencies `git-core build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config`
  # RVM is installed via `curl -L https://get.rvm.io | bash -s stable`
  # Log out, log back in (PATH changes need to take effect)
  # RVM `zlib` package installed via `rvm pkg install zlib --verify-downloads 1`
  # Necessary Ruby version installed
  # `gem install bundler --no-ri --no-rdoc`
  #
  # ------# Now that you have a working version of Ruby installed =------
  #
  # To setup app on new server (these are all one-time run tasks):
  # cap [env] deploy:install      <== Installs app version of Ruby, package dependencies
  # cap [env] deploy:setup        <== Sets up magic app links, folders, etc.
  # cap [env] deploy:cold         <== Initial deploy of the actual application
    
  desc "Install application dependencies and web server."
  task :install do
    install_app_package_dependencies
    nginx.install
  end
    
  desc "Installs system packages required by the app"
  task :install_app_package_dependencies, roles: :app do
    required_packages = ["libxml2",       # Required by `nokogiri` gem
                         "libxslt-dev",   # Required by `nokogiri` gem
                         "libxml2-dev",   # Required by `nokogiri` gem
                         "libpq-dev"]     # Required by `pg` gem
    
    required_packages.each do |package|
      run "#{sudo} apt-get -y install #{package}"
    end
  end
    
  task :setup_config, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.example.yml"
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
  
  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
end
