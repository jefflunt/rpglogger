namespace :s3ql do
  desc "Creates the necessary mount points for S3QL"
  task :install, roles: :web do
    run "#{sudo} mkdir -p /mnt/s3/#{application}"
    run "#{sudo} chown #{user}:#{user} /mnt/s3/#{application}"
  end
  
  desc "Create the nginx config for this application"
  task :regenerate_config, roles: :web do
    run "mkdir -p /home/#{user}/.s3ql"
    
    template "s3ql.conf.erb",     "#{shared_path}/config/s3ql.conf"
    template "s3ql_authinfo.erb", "#{shared_path}/config/s3ql_authinfo"
    
    run "#{sudo} ln -nfs #{shared_path}/config/s3ql.conf /etc/init/s3ql.conf"
    run "ln -nfs #{shared_path}/config/s3ql_authinfo /home/#{user}/.s3ql/authinfo"
  end
  after "deploy:setup", "s3ql:regenerate_config"
end