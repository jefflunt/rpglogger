namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    run "#{sudo} add-apt-repository ppa:nginx/stable"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    
    regenerate_config
  end
  
  desc "Create the nginx config for this application"
  task :regenerate_config, roles: :web do
    template "nginx_unicorn.erb", "/tmp/nginx_unicorn"
    run "#{sudo} mv /tmp/nginx_unicorn /etc/nginx/sites-enabled/#{application}"
  end
  
  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end