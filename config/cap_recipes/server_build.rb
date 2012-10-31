namespace :build do
  desc "Builds server from a blank OS image"
  task :from_scratch, roles: :web do
    puts "====== rpglogger bootstrap - adventure awaits ======"

    # Add S3QL to source repositories, then upgrade all packages, then install S3QL
    run "#{sudo} add-apt-repository ppa:nikratio/s3ql"    
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y upgrade"
    run "#{sudo} apt-get -y install s3ql"

    # Install RVM dependencies in two steps, then install RVM
    run "#{sudo} apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison pkg-config"
    run "#{sudo} -y install libsqlite3-dev sqlite3 subversion"
    run "curl -sL https://get.rvm.io | bash -s stable"
    
    # Move contents of .bash_profile into .bashrc, then re-source it
    run "cat ~/.bashrc >> ~/.bash_profile"
    run "mv ~/.bash_profile ~/.bashrc"
    run "source /home/$USER/.rvm/scripts/rvm"

    # Install RVM zlib package, then required version of Ruby
    run "rvm pkg install zlib --verify-downloads 1"
    run "rvm install ruby-1.9.2-p320"
    
    # Install bundler gem
    run "gem install bundler --no-ri --no-rdoc"
    
    # Next steps
    puts "======> NOTES <================================================"
    puts "Bootstrap finished!"
    puts "NOW, SETUP the ENV variables and aliases for $USER"
    puts "Use 'cap [env] deploy:install' to continue with app deployment."
    puts "==============================================================="
  end
end
