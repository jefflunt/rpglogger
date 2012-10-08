namespace :unicorn do
  desc "Create the unicorn.rb file for configuring unicorn for this app"
  task :regenerate_config, roles: :web do
    template "unicorn.erb", "#{current_path}/config/unicorn.rb"
    run "#{sudo} ln -nfs #{current_path}/config/unicorn_init_#{rails_env}.sh /etc/init.d/unicorn_#{application}"
    restart
  end
  
  after "deploy:finalize_update", "unicorn:regenerate_config"
  
  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :web do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
end