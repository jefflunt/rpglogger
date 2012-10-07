namespace :unicorn do
  desc "Create the unicorn.rb file for configuring unicorn for this app"
  task :setup, roles: :web do
    template "unicorn.erb", "#{current_path}/config/unicorn.rb"
    run "#{sudo} ln -nfs #{current_path}/config/unicorn_init_#{rails_env}.sh /etc/init.d/unicorn_#{application}"
    restart
  end
  
  after "deploy:setup", "unicorn:setup"
  
  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :web do
      run "/etc/init.d/unidorn_#{application} #{command}"
    end
  end
end