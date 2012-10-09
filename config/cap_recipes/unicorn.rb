set_default(:unicorn_user) { user }
set_default(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.#{application}.pid" }
set_default(:unicorn_config) { "#{shared_path}/config/unicorn.rb"}
set_default(:unicorn_log) { "#{shared_path}/log/unicorn.#{application}.log" }
set_default(:unicorn_listen) { "/tmp/unicorn.#{application}.sock" }
set_default(:unicorn_workers, 2)
set_default(:unicorn_timeout, 30)
set_default(:should_preload_app, true)

namespace :unicorn do
  desc "Create the unicorn.rb file for configuring unicorn for this app"
  task :regenerate_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.erb", "/tmp/unicorn_init"
    run "chmod +x /tmp/unicorn_init"
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}"
    run "#{sudo} update-rc.d -f unicorn_#{application} defaults"
  end
  after "deploy:setup", "unicorn:regenerate_config"
end