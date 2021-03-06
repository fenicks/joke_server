# frozen_string_literal: true
require 'fileutils'

# Unicorn configuration file
app_root = File.expand_path(Dir.getwd)
working_directory app_root

# workers + the master process
sinatra_env = ENV['RACK_ENV'] || 'development'
worker_processes(sinatra_env.to_s.casecmp('production').zero? ? 4 : 2)

log_dir = File.expand_path(File.join(app_root, 'logs'))
FileUtils.mkdir_p(log_dir) unless Dir.exist?(log_dir)

log_file = File.expand_path(File.join(log_dir, "joke_#{sinatra_env}.log"))
stderr_path log_file
stdout_path log_file

# before_fork do |server, worker|
#  # do something
# end

after_fork do |_server, _worker|
  if defined?(Ohm)
    # default 'redis://localhost:6379/0'
    Ohm.redis = Redic.new('redis://localhost:6379/0', 30)
  end
end
