# frozen_string_literal: true
require 'sinatra/base'
require 'sinatra/json'
require 'oj'
require 'sinatra/namespace'
require 'ohm'
require 'ohm/json'
require 'logger'

require_relative 'models/joke'

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
    set :logging
  end

  helpers Sinatra::JSON

  not_found do
    json(error: 'Not found')
  end

  error do
    json(error: "#{env['sinatra.error'].name}: #{env['sinatra.error'].message}")
  end

  get '/hi' do
    json(msg: 'Hello World!')
  end

  namespace '/v1' do
    get '/status' do
      # status 200
      json(service: 'status')
    end

    get '/healthCheck' do
      store_file = File.join(settings.root, 'models', 'joke_store.mock.json')
      if File.file?(store_file)
        json(service: 'healthCheck')
      else
        logger.error "File #{store_file} doesn't exist"
        halt 503, json(error: 'Service Unavailable')
      end
    end

    get '/joke' do
      store_file = File.join(settings.root, 'models', 'joke_store.mock.json')
      begin
        raise 'Store file error' unless File.file?(store_file)
        data = File.open(store_file, 'r:utf-8', &:read)
        data = JSON.parse(data)
        data = data['joke_store']
        length = data.length
        index = rand(length)
        json(joke: data[index])
      rescue => e
        logger.error e.to_s
        json(joke: 'Joker!')
      end
    end
  end

  namespace '/v2' do
    get '/healthCheck' do
      if 'PONG' == Ohm.redis.call('PING')
        json(service: 'healthCheck')
      else
        logger.error 'Redis is not responding'
        halt 503, json(error: 'Service Unavailable')
      end
    end

    get '/joke/?:id?' do
      j = nil
      if params[:id]
        j = Joke[params[:id].to_i]
      else
        jokes = Joke.all.to_a
        j = jokes[rand(jokes.length)] if jokes && !jokes.empty?
      end
      if j
        json(joke: j.joke)
      else
        halt 404, json(error: 'No joke found')
      end
    end

    post '/joke' do
      if params[:joke] && !params[:joke].empty?
        begin
          Joke.create(joke: params[:joke])
        rescue => e
          logger.error e.to_s
          halt 400, json(error: 'Bad Request')
        end
        json(service: 'joke', msg: 'created successfully')
      else
        halt 403, json(error: 'Forbidden')
      end
    end

    delete '/joke/:id' do |id|
      j = Joke[id.to_i]
      if j
        j.delete
        json(service: 'joke', msg: 'deleted successfully')
      else
        logger.error "Joke #{id} doesn't exist"
        halt 403, json(error: 'Forbidden')
      end
    end

    patch '/joke/:id' do |id|
      j = Joke[id.to_i]
      if j && params[:joke] && !params[:joke].empty?
        j.joke = params[:joke]
        begin
          j.save
          json(service: 'joke', msg: 'saved successfully')
        rescue => e
          logger.error e.to_s
          halt 400, json(error: 'Bad Request')
        end
      else
        logger.error "Joke #{id} doesn't exist"
        halt 403, json(error: 'Forbidden')
      end
    end
  end
end
