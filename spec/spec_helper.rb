# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'capybara/rspec'
require 'ohm'
require 'simplecov'

SimpleCov.start

require_relative '../joke_server'

module RSpecMixin
  include Rack::Test::Methods
  include Capybara::DSL

  Ohm.redis = Redic.new('redis://localhost:6379/0', 10)

  def app
    JokeServer
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
end
