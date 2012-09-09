root = "/home/deployer/apps/rpglogger/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.rpglogger.pid"
stderr_path "#{root}/log/unicorn.rpglogger.log"
stdout_path "#{root}/log/unicorn.rpglogger.log"

listen "/tmp/unicorn.rpglogger.sock"
worker_processes 2
timeout 30
