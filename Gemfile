source 'https://rubygems.org'

ruby '2.1.2'

gem 'bundler'
gem 'unicorn'
gem 'sinatra'#, require: 'sinatra/base'
gem 'sinatra-contrib'
gem 'hiredis'
gem 'redis', require: %w(redis/connection/hiredis redis)
gem 'ohm'
gem 'ohm-contrib'

group :test do
  gem 'rack-test'
  gem 'simplecov', require: false
end