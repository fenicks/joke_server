require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'sinatra/namespace'
require 'hiredis'
require 'redis'
require 'connection_pool'

## Redis over ConnectionPool
$redis ||= ::ConnectionPool.new(size: 4, timeout: 60) do
  url = URI('redis://localhost:6379/0')
  Redis.new(host: url.host, port: url.port, driver: :hiredis, db: 0)
end

class JokeServer < Sinatra::Base
  register Sinatra::Namespace

  configure do
    enable :logging
  end

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    set :logging, Logger::DEBUG
  end

  configure :production do
    set :logging, Logger::INFO
  end

  helpers Sinatra::JSON

  get '/hi' do
    json({msg: 'Hello World!'})
  end

  namespace '/v1' do
    get '/status' do
      #status 200
      json({service: 'status'})
    end

    get '/healthCheck' do
      #store_file = File.join(settings.root, 'models', 'joke_store.mock.json')
      if 'PONG' == $redis.with { |r| r.ping } #File.file?(store_file)
        json({service: 'healthCheck'})
      else
        status 500 # Internal Server Error
        json({service: 'healthCheck', error: 'Internal Server Error'})
        #logger.error "File #{store_file} doesn't exist"
        logger.error 'Redis is not responding'
      end
    end

    get '/joke' do
      store_file = File.join(settings.root, 'models', 'joke_store.mock.json')
      begin
        if File.file?(store_file)
          data = File.open(store_file, 'r:utf-8') do |f|
            f.read
          end
          data = JSON.parse(data)
          data = data['joke_store']
          length = data.length
          index = rand(length)
          json({joke: data[index]})
        else
          raise RuntimeError, 'Store file error'
        end
      rescue => e
        logger.error e.to_s
        json({joke: 'Joker!'})
      end
    end
  end
end