require 'fileutils'

# Unicorn configuration file
app_root = File.expand_path(Dir.getwd)
working_directory app_root

# workers + the master process
sinatra_env = ENV['RACK_ENV']||'development'
worker_processes(sinatra_env.to_s.downcase == 'production' ? 8 : 4)

log_dir = File.expand_path(File.join(app_root, 'logs'))
unless Dir.exist?(log_dir)
  FileUtils.mkdir_p log_dir
end
log_file = File.expand_path(File.join(log_dir, "joke_server_#{sinatra_env}.log"))
stderr_path log_file
stdout_path log_file

before_fork do |server, worker|
  if defined?(Ohm::Model)
    Ohm::Model.conn.reset!
  end
end

after_fork do |server, worker|
  if defined?(Ohm)
    # default 'redis://localhost:6379/0'
    if defined?(Ohm::Model)
      Ohm::Model.connect
    end
  end
end

