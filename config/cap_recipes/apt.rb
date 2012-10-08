namespace :apt do  
  %w[update upgrade].each do |command|
    desc "#{command} apt-get"
    task command, roles: :web do
      run "#{sudo} apt-get #{command} -y"
    end
  end
  
  desc "Install native library dependencies for this application"
  task :install_app_dependencies do
    run "#{sudo} apt-get install libpq-dev"
  end
end