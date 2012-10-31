def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def step_output(current_step, total_steps, msg)
  puts "------> (#{current_step}/#{total_steps}) #{msg}"
end