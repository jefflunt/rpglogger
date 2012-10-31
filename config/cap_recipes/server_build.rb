namespace :server do
  set :total_steps, 10
  set :server_step, 0
  
  desc "Builds server from a blank OS image"
  task :build, roles: :web do
    puts "====== rpglogger bootstrap - adventure awaits ======"
    
    add_s3ql_package_source_to_apt
    update_package_source_lists
    upgrade_all_installed_packages
    
    install_rvm_dependencies
    install_s3ql_dependencies
    install_rvm_in_single_user_mode
    move_profile_contents_to_bashrc_file
    install_rvm_zlib_package
    install_ruby192_into_rvm
    install_bundler_gem
    
    output_next_steps
  end
  
  desc "Adds the S3QL package sources to apt."
  task :add_s3ql_package_source_to_apt, roles: :web do
    step_output(server_step++, total_steps, "Adding S3QL package source to apt...")
    run "#{sudo} add-apt-repository ppa:nikratio/s3ql"
  end
  
  desc "Updates package sources"
  task :update_package_source_lists, roles: :web do
    step_output(server_step++, total_steps, "Updating all package sources...")
    run "#{sudo} apt-get -y update"
  end
  
  desc "Upgrades already installed packages"
  task :upgrade_all_installed_packages, roles: :web, do
    step_output(server_step++, total_steps, "Upgrading already installed packages (SLOW)...")
    run "#{sudo} apt-get -y upgrade"
  end
  
  desc "Installing RVM dependencies"
  task :install_rvm_dependencies, roles: :web do
    step_output(server_step++, total_steps, "Installing RVM package dependencies...")
    run "#{sudo} apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison pkg-config"
    run "#{sudo} -y install libsqlite3-dev sqlite3 subversion"
  end
  
  desc "Install S3QL package dependencies"
  task :install_s3ql_dependencies, roles: :web do
    step_output(server_step++, total_steps, "Installing S3QL package dependencies...")
    run "#{sudo} apt-get -y install s3ql"
  end
  
  desc "Install RVM in single user mode"
  task :install_rvm_in_single_user_mode, roles: :web do
    step_output(server_step++, total_steps, "Installing RVM in single-user mode...")
    run "curl -sL https://get.rvm.io | bash -s stable"
  end
  
  desc "Move .bash_profile contents to .bashrc"
  task :move_profile_contents_to_bashrc_file, roles: :web do
    step_output(server_step++, total_steps, "Moving .bash_profile contents to .bashrc...")
    
    # Not sure what to do here just yet
    run "cat ~/.bashrc >> ~/.bash_profile"
    run "mv ~/.bash_profile ~/.bashrc"
    run "source /home/$USER/.rvm/scripts/rvm"
  end
  
  desc "Install RVM zlib package"
  task :install_rvm_zlib_package, roles: :web do
    step_output(server_step++, total_steps, "Installing RVM zlib package...")
    run "rvm pkg install zlib --verify-downloads 1"
  end
  
  desc "Install Ruby 1.9.2 compiles from source"
  task :install_ruby192_into_rvm, roles: :web do
    step_output(server_step++, total_steps, "Installing Ruby 1.9.2. Compiling from source (SLOW)...")
    run "rvm install ruby-1.9.2-p320"
  end
  
  desc "Install 'bundler' gem"
  task :install_bundler_gem, roles: :web do
    step_output(server_step++, total_steps, "Installing 'bundler' gem...")
    run "gem install bundler --no-ri --no-rdoc"
  end
  
  task :output_next_steps do
    puts "======> NOTES <================================================"
    puts "Bootstrap finished!"
    puts "NOW, SETUP the ENV variables and aliases for $USER"
    puts "Use 'cap [env] deploy:install' to continue with app deployment."
    puts "==============================================================="
  end
end
