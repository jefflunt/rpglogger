namespace :unicorn do
  desc "Create the unicorn.rb file for configuring unicorn for this app"
  task :regenerate_config, roles: :web do
    template "unicorn.erb", "#{deploy_to}/current/config/unicorn.rb"
    run "#{sudo} ln -nfs #{deploy_to}/current/config/unicorn_init_#{rails_env}.sh /etc/init.d/unicorn_#{application}"
    restart
  end
  after "deploy:update_code", "unicorn:regenerate_config"
  
  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :web do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
end