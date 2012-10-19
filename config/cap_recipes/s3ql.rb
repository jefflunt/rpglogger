namespace :s3ql do
  desc "Creates the necessary mount points for S3QL"
  task :install, roles: :app do
    run "#{sudo} mkdir -p /mnt/s3/#{application}"
    run "#{sudo} chown #{user}:#{user} /mnt/s3/#{application}"
    run "touch /mnt/s3/#{application}/local-storage"    # An empty file to easily indicate if we're on mounted or local storage
  end
  
  desc "Create the S3QL config for this application"
  task :regenerate_config, roles: :app do
    run "mkdir -p /home/#{user}/.s3ql"
    
    # Customized fuse.conf
    template "fuse.conf.erb", "/tmp/fuse.conf"
    run "#{sudo} mv /tmp/fuse.conf /etc/fuse.conf"
    
    # Create init script and credentials file from templates. Set permissions.
    template "s3ql.conf.erb",     "/tmp/s3ql.conf"
    template "s3ql_authinfo.erb", "/home/#{user}/.s3ql/authinfo2"
    run "chmod 600 /home/#{user}/.s3ql/authinfo2"
    
    # Move S3QL config to its ultimate location
    run "#{sudo} mv /tmp/s3ql.conf /etc/init/s3ql.conf"
  end
  after "deploy:setup", "s3ql:regenerate_config"
end