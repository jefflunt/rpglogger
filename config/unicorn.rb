root = "/home/deployer/apps/rpglogger"
current = "#{rood}/current"
shared = "#{root}/shared"

working_directory root

pid "#{shared}/pids/unicorn.rpglogger.pid"
stderr_path "#{current}/log/unicorn.rpglogger.log"
stdout_path "#{current}/log/unicorn.rpglogger.log"

listen "/tmp/unicorn.rpglogger.sock"
worker_processes 2
timeout 30
