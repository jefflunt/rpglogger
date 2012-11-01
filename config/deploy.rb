require "bundler/capistrano"

load "config/cap_recipes/cap_helpers"
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
default_run_options[:shell] = '/bin/bash'
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
  set_roles
  
  nginx.regenerate_config
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
  desc "Builds server from a blank OS image"
  task :bootstrap, roles: :web do
    puts '
                         .__                                      
    _____________   ____ |  |   ____   ____   ____   ___________  
    \_  __ \____ \ / ___\|  |  /  _ \ / ___\ / ___\_/ __ \_  __ \ 
     |  | \/  |_> > /_/  >  |_(  <_> ) /_/  > /_/  >  ___/|  | \/ 
     |__|  |   __/\___  /|____/\____/\___  /\___  / \___  >__|    
           |__|  /_____/            /_____//_____/      \/        
     ____________________________________________________________ 
    /_____/_____/_____/_____/_____/_____/_____/_____/_____/_____/ 


                .___                    __                        
    _____     __| _/__  __ ____   _____/  |_ __ _________   ____  
    \__  \   / __ |\  \/ // __ \ /    \   __\  |  \_  __ \_/ __ \ 
     / __ \_/ /_/ | \   /\  ___/|   |  \  | |  |  /|  | \/\  ___/ 
    (____  /\____ |  \_/  \___  >___|  /__| |____/ |__|    \___  >
         \/      \/           \/     \/                        \/ 
                                   .__  __                        
             _____ __  _  _______  |__|/  |_  ______              
             \__  \\ \/ \/ /\__  \ |  \   __\/  ___/              
              / __ \\     /  / __ \|  ||  |  \___ \               
             (____  /\/\_/  (____  /__||__| /____  >              
                  \/             \/              \/               
    '

    # Update all installed packages, and add S3QL repository to apt sources
    run "#{sudo} add-apt-repository ppa:nikratio/s3ql"    
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y upgrade"
    run "#{sudo} apt-get -y install s3ql"
    
    # Install RVM dependencies in two steps, then install RVM
    run "#{sudo} apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison pkg-config"
    run "#{sudo} apt-get -y install libsqlite3-dev sqlite3 subversion"
    run "curl -sL https://get.rvm.io | bash -s stable"
    
    # Move contents of .bash_profile into .bashrc, then re-source it
    run "cat /home/#{user}/.bashrc >> /home/#{user}/.bash_profile"
    run "mv /home/#{user}/.bash_profile ~/.bashrc"
    run "source /home/#{user}/.rvm/scripts/rvm"
    run "source /home/#{user}/.bashrc"
    
    # Install RVM zlib package, then required version of Ruby
    puts ""
    puts "======================================================================="
    puts "| About to install Ruby and the zlib package - this takes a long time |"
    puts "======================================================================="
    puts ""
    run "rvm --skip-autoreconf pkg install zlib"
    run "rvm install ruby-1.9.2-p320"
    run "rvm --default use 1.9.2"
    
    # Install bundler gem
    run "gem install bundler --no-ri --no-rdoc"
    
    # Next steps
    puts "======> NOTES <================================================"
    puts "Bootstrap finished!"
    puts "NOW, SETUP the ENV variables and aliases for #{user}"
    puts "Use 'cap [env] deploy:install' to continue with app deployment."
    puts "==============================================================="
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
