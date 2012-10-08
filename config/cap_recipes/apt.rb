namespace :apt do  
  %w[update upgrade].each do |command|
    desc "#{command} apt-get"
    task command, roles: :web do
      run "#{sudo} apt-get -y #{command}"
    end
  end
end