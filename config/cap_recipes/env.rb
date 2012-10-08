namespace :env do
  desc "Set production settings"
  task :production do
    set :app_server, "rpglogger.com"
    set :rails_env, "production"
    set_roles
  end

  desc "Set staging settings"
  task :staging do
    set :app_server, "staging.rpglogger.com"
    set :rails_env, "staging"
    set_roles
  end
  
  desc "Set local development VM"
  task :dev_vm do
    set :app_server, "192.168.0.100"
    set :rails_env, "development"
    set_roles
  end
end