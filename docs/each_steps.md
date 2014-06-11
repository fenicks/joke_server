# Build web service by example

## Step 1 : Init

 * Create joke_server directory
 * Create this files : .versions.conf - Gemfile - joke_server.rb
 * Populate .version.conf

        ruby=ruby-2.1.2
        ruby-gemset=joke_server

 * Populate Gemfile

        source 'https://rubygems.org'

        ruby '2.1.2'

        gem 'bundler'
        gem 'sinatra'

 * Populate joke_server.rb

        require 'sinatra'

        get '/hi' do
          'Hello World!'
        end

 * Install Bundler

        gem install bundler

 * Exec bundle install

        bundle install
        # bundle update

 * Run the app

        ruby joke_server.rb

## Step 2 : Set modularized Sinatra

 * Update joke_server.rb

        require 'sinatra/base'

        class JokeServer < Sinatra::Base
          get '/hi' do
            'Hello World!'
          end
        end

 * Update config.ru

        require_relative 'joke_server'

        run JokeServer.new

 * Run the app

         rackup config.ru

## Step 3 : Add Json Support

 * Update Gemfile with sinatra/contrib

        source 'https://rubygems.org'

        ruby '2.1.2'

        gem 'bundler'
        gem 'sinatra'
        gem 'sinatra-contrib'

 * Update joke_server.rb

        require 'sinatra/base'
        require 'sinatra/json'
        require 'json'

        class JokeServer < Sinatra::Base

          helpers Sinatra::JSON

          get '/hi' do
            json({msg: 'Hello World!'})
          end
        end

## Step 3 : Add sinatra reloader

 * Update Gemfile with sinatra/contrib

        source 'https://rubygems.org'

        ruby '2.1.2'

        gem 'bundler'
        gem 'sinatra'
        gem 'sinatra-contrib'

* Update joke_server.rb

        require 'sinatra/base'
        require 'sinatra/json'
        require 'json'

        class JokeServer < Sinatra::Base

          configure :development do
            require 'sinatra/reloader'
            register Sinatra::Reloader
          end

          helpers Sinatra::JSON

          get '/hi' do
            json({msg: 'Hello World!'})
          end
        end

 * Run bundle install

        bundle install

 * Re-run the app

        unicorn -E ${RACK_ENV:-development} --config=./config/unicorn.rb --port=${PORT:-5000}

## Step 4 : Add unicorn

 * Update Gemfile

        source 'https://rubygems.org'

        ruby '2.1.2'

        gem 'bundler'
        gem 'unicorn'
        gem 'sinatra'
        gem 'sinatra-contrib'

 * Create config/unicorn.rb

        require 'fileutils'

        # Unicorn configuration file
        app_root = File.expand_path(Dir.getwd)
        working_directory app_root

        # workers + the master process
        sinatra_env = ENV['RACK_ENV']||'development'
        worker_processes(sinatra_env.to_s.downcase == 'production' ? 8 : 4)

        # log_dir = File.expand_path(File.join(app_root, 'logs'))
        # unless Dir.exist?(log_dir)
        #   FileUtils.mkdir_p log_dir
        # end
        # log_file = File.expand_path(File.join(log_dir, "joke_server_#{sinatra_env}.log"))
        # stderr_path log_file
        # stdout_path log_file

 * Launch command (add in run.sh)

        unicorn -E ${RACK_ENV:-development} --config=./config/unicorn.rb --port=${PORT:-5000}

## Step 5 : Add mock data store for jokes

 * Create models/joke_store.mock.json

        {
            "joke_store_current_id": 5,
            "joke_store": [
                {
                    "id": 1,
                    "joke": "Deux asticots se retrouvent dans une pomme :\n- Tiens ! Je ne savais pas que vous habitiez le quartier !",
                    "created_at": "2014-06-12T17:00:00+00:00"
                },
                {
                    "id": 2,
                    "joke": "Une mère dit à son garçon :\n-N'oublie pas que nous sommes sur terre pour travailler.\n- Bon, alors moi, plus tard je serai marin !",
                    "created_at": "2014-06-12T17:05:00+00:00"
                },
                {
                    "id": 3,
                    "joke": "Je suis inquiet, je vois des points noirs.\n- Tu a vu l'oculiste ?\n- Non, des points noirs !",
                    "created_at": "2014-06-12T17:10:00+00:00"
                },
                {
                    "id": 4,
                    "joke": "- J'ai aperçu ta copine l'autre jour, mais elle ne m'a pas vu !\n- Je sais, elle me l'a dit.",
                    "created_at": "2014-06-12T17:15:00+00:00"
                },
                {
                    "id": 5,
                    "joke": "- Monsieur, savez-vous que votre chien aboie toute la nuit ?\n- Oh, ça ne fait rien, il dort toute la journée !",
                    "created_at": "2014-06-12T17:20:00+00:00"
                }
            ]
        }

## Step 6 : Add namespace and technical web service

 * Activate Sinatra logs and Update joke_server.rb

        require 'sinatra/base'
        require 'sinatra/json'
        require 'json'
        require 'sinatra/namespace'

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
              store_file = File.join(settings.root, 'models', 'joke_store.mock.json')
              if File.file?(store_file)
                json({service: 'healthCheck'})
              else
                logger.error "File #{store_file} doesn't exist"
                halt 503, json({error: 'Service Unavailable'})
              end
            end
          end
        end

 * Activate unicorn log in file

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

 * Re-run the app

        unicorn -E ${RACK_ENV:-development} --config=./config/unicorn.rb --port=${PORT:-5000}

 * Test /healthCheck with non exist file and tail the log file
 * Test getting random joke

        require 'sinatra/base'
        require 'sinatra/json'
        require 'json'
        require 'sinatra/namespace'

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
              store_file = File.join(settings.root, 'models', 'joke_store.mock.json')
              if File.file?(store_file)
                json({service: 'healthCheck'})
              else
                logger.error "File #{store_file} doesn't exist"
                halt 503, json({error: 'Service Unavailable'})
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

## Step 7 : Add redis as datastore, redis-objects and redis connection in unicorn config

 * Update Gemfile

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


 * Create redis connection in unicorn.rb

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

 * Run bundle install

        bundle install

 * Create joke model: models/joke.rb

        require 'ohm'
        require 'ohm/contrib'

        class Joke < Ohm::Model
          include Ohm::Timestamps

          attribute :joke
          unique    :joke
          index     :joke
        end

 * Add Ohm require in `joke_server.rb`

        require 'ohm'
        require 'ohm/json'

        require_relative 'models/joke'

 * Update /healthCheck and /joke - Add POST:/joke for joke create : /v2 API (show halt method)

        namespace '/v2' do
          get '/healthCheck' do
            if 'PONG' == Ohm.redis.call('PING')
              json({service: 'healthCheck'})
            else
              logger.error 'Redis is not responding'
              halt 503, json({error: 'Service Unavailable'})
            end
          end

          get '/joke/?:id?' do
            j = nil
            if params[:id]
              j = Joke[params[:id].to_i]
            else
              jokes = Joke.all.to_a
              if jokes && jokes.length > 0
                j = jokes[rand(jokes.length)]
              end
            end
            if j
              json({joke: j.joke})
            else
              halt 404, json({error: 'No joke found'})
            end
          end

          post '/joke' do
            if params[:joke] && params[:joke].length > 0
              begin
                j = Joke.create(joke: params[:joke])
                j.save
                json({service: 'joke', msg: 'created successfully'})
              rescue => e
                logger.error e.to_s
                halt 400, json({error: 'Bad Request'})
              end
            else
              halt 403, json({error: 'Forbidden'})
            end
          end

          delete '/joke/:id' do |id|
            j = Joke[id.to_i]
            if j
              j.delete
            else
              logger.error "Joke #{id} doesn't exist"
              halt 403, json({error: 'Forbidden'})
            end
          end


        end

 * 404 and 500 error after `helpers Sinatra::JSON` statement

        not_found do
          json({error: 'Not found'})
        end

        error do
          json({error: "#{env['sinatra.error'].name}: #{env['sinatra.error'].message}"})
        end

## Add test

 * Create `test` dir
 * Add test gems in Gemfile

        group :test do
          gem 'rack-test'
          gem 'simplecov', require: false
        end

 * Run bundle install

        bundle install

 * Add test/test_helper.rb

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

 * Create Rakefile

        require 'rake/clean'
        require 'rake/testtask'

        task default: :test

        Rake::TestTask.new(:test) do |t|
          t.test_files = FileList['test/**/*_test.rb']
          t.warning = false
        end

 * Create test/models/joke_test.rb

        require_relative '../test_helper'
        require_relative '../../models/joke'

        class JokeTest < Test::Unit::TestCase
          def setup
            Ohm.redis.call('flushall')
            [{joke: 'First'}, {joke: 'Second'}, {joke: 'Third'}].each do |j|
              Joke.create(j)
            end
          end

          def teardown
            Ohm.redis.call('flushall')
          end

          def test_joke_create
            %w(First Second Third).each do |d|
              j = Joke.with(:joke, d)
              assert_not_nil j
              assert_equal d, j.joke
            end
          end

          def test_joke_update
            third = 'Third'
            j = Joke.with(:joke, third)
            third_updated = 'Third updated'
            j.joke = third_updated
            j.save
            assert_equal third_updated, j.joke
            j.joke = third
            j.save
            assert_equal third, j.joke
          end

          def test_joke_delete
            third = 'Third'
            j = Joke.with(:joke, third)
            j.delete
            j = Joke.with(:joke, third)
            assert_nil j
            j = Joke.create(joke: third)
            j.save
          end
        end

 * Create in test/functional hi_test.rb, status_test.rb, health_check_test.rb, joke_test.rb