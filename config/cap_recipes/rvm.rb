namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end
after "deploy:update_code", "rvm:trust_rvmrc"
