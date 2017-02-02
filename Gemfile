source 'https://rubygems.org'

#ruby '2.1.4'

gem 'bundler'
gem 'unicorn', '~> 4.8.3' # This change was made via Snyk to fix a vulnerability
gem 'sinatra'#, '~> 1.4.5' # This change was made via Snyk to fix a vulnerability
gem 'sinatra-contrib'
gem 'hiredis'
gem 'redis', require: %w(redis/connection/hiredis redis)
gem 'ohm'
gem 'ohm-contrib'

group :test do
  gem 'rake'
  gem 'rack-test'
  gem 'simplecov', require: false
end