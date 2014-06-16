ENV['RACK_ENV'] = 'test'

begin
  require 'simplecov'
  #SimpleCov.minimum_coverage 50
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/config/'
  end
rescue
  puts '[ERROR]: SimpleCov is not loaded!'
end

require 'test/unit'
require 'rack/test'
require 'ohm'

require_relative '../joke_server'

class Test::Unit::TestCase
  include Rack::Test::Methods
  Ohm.redis = Redic.new('redis://localhost:6379/0')

  def app
    JokeServer
  end
end