namespace :apt do  
  %w[update upgrade install remove autoremove].each do |command|
    desc "#{command} apt-get package(s)"
    task command, roles: :web do
      run "#{sudo} apt-get #{command} -y #{ENV["PACKAGES"]}"
    end
  end
end