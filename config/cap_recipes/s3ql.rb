namespace :s3ql do
  desc "Creates the necessary mount points for S3QL"
  task :install, roles: :app do
    run "#{sudo} mkdir -p /mnt/s3/#{application}"
    run "#{sudo} chown #{user}:#{user} /mnt/s3/#{application}"
  end
  
  desc "Create the nginx config for this application"
  task :regenerate_config, roles: :app do
    run "mkdir -p /home/#{user}/.s3ql"
    
    # Create init script and credentials file from templates. Set permissions.
    template "s3ql.conf.erb",     "#{shared_path}/config/s3ql.conf"
    template "s3ql_authinfo.erb", "/home/#{user}/.s3ql/authinfo2"
    run "chmod 600 /home/#{user}/.s3ql/authinfo2"
    
    # Create symbolic links
    run "#{sudo} ln -nfs #{shared_path}/config/s3ql.conf /etc/init/s3ql.conf"
  end
  after "deploy:setup", "s3ql:regenerate_config"
end