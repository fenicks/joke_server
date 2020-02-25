# frozen_string_literal: true
source 'https://rubygems.org'

gem 'bundler'
gem 'unicorn', '~> 4.8.3' # This change was made via Snyk to fix a vulnerability
gem 'sinatra'#, '~> 1.4.5' # This change was made via Snyk to fix a vulnerability
gem 'sinatra-contrib'
gem 'hiredis'
gem 'redis', require: %w(redis/connection/hiredis redis)
gem 'ohm'
gem 'ohm-contrib'
gem 'oj'
gem 'oj_mimic_json'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'unicorn'

group :test do
  gem 'capybara'
  gem 'rainbow', '~>2.0', '!=2.2.1'
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov'
end
