# ------= Provision the server =------
namespace :provision do
  desc "Provisions a server from scratch"
  task :default do
    update_system_packages    
    setup_ruby_and_rvm
    install_app_specific_packages
  end
  
  desc "Updates the packages already installed on the system"
  task :update_system_packages do
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get -y upgrade"
  end
  
  desc "Installs RVM and required Ruby version"
  task :setup_ruby_and_rvm do
    rvm.install_rvm
    rvm.install_ruby
  end
  
  desc "Installs the app-specific packages"
  task :install_app_specific_packages do
    required_packes = ["libpq-dev"]
    
    required_packages.each do |package|
      run "#{sudo} apt-get -y install #{package}"
    end
  end
end
