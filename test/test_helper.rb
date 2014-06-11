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

require_relative '../joke_server'

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    JokeServer
  end
end