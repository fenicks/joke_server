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
        bundle update

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

        unicorn -E ${RACK_ENV:-development} --config=./unicorn.rb --port=${PORT:-5000}

## Step 4 : Add unicorn

 * Update Gemfile

        source 'https://rubygems.org'

        ruby '2.1.2'

        gem 'bundler'
        gem 'unicorn'
        gem 'sinatra'
        gem 'sinatra-contrib'

 * Create unicorn.rb

        require 'fileutils'

        # Unicorn configuration file
        app_root = File.expand_path(Dir.getwd)
        working_directory app_root

        # workers + the master process
        sinatra_env = ENV['RACK_ENV']||'development'
        worker_processes(sinatra_env.to_s.downcase == 'production' ? 8 : 4)

        # log_dir = File.expand_path(File.join(app_root, 'log'))
        # unless Dir.exist?(log_dir)
        #   FileUtils.mkdir_p log_dir
        # end
        # log_file = File.expand_path(File.join(log_dir, "joke_server_#{sinatra_env}.log"))
        # stderr_path log_file
        # stdout_path log_file

 * Launch command (add in run.sh)

        unicorn -E ${RACK_ENV:-development} --config=./unicorn.rb --port=${PORT:-5000}

## Step 5 : Add mock data store for jokes

 * Create models/joke_store.mock.json

        {
            "joke_store": [
                {
                    "id": 1,
                    "content": "Deux asticots se retrouvent dans une pomme :\n- Tiens ! Je ne savais pas que vous habitiez le quartier !",
                    "created_at": "2014-06-12T17:00:00+00:00"
                },
                {
                    "id": 2,
                    "content": "Une mère dit à son garçon :\n-N'oublie pas que nous sommes sur terre pour travailler.\n- Bon, alors moi, plus tard je serai marin !",
                    "created_at": "2014-06-12T17:05:00+00:00"
                },
                {
                    "id": 3,
                    "content": "Je suis inquiet, je vois des points noirs.\n- Tu a vu l'oculiste ?\n- Non, des points noirs !",
                    "created_at": "2014-06-12T17:10:00+00:00"
                },
                {
                    "id": 4,
                    "content": "- J'ai aperçu ta copine l'autre jour, mais elle ne m'a pas vu !\n- Je sais, elle me l'a dit.",
                    "created_at": "2014-06-12T17:15:00+00:00"
                },
                {
                    "id": 5,
                    "content": "- Monsieur, savez-vous que votre chien aboie toute la nuit ?\n- Oh, ça ne fait rien, il dort toute la journée !",
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
              if File.file?(File.join(settings.root, 'models', 'joke_store.mock.json'))
                json({service: 'healthCheck'})
              else
                status 500 # Internal Server Error
                json({service: 'healthCheck', error: 'Internal Server Error'})
                logger.error "File #{store_file} doesn't exist"
              end
            end
          end
        end

 * Activate uncorn log in file

        require 'fileutils'

        # Unicorn configuration file
        app_root = File.expand_path(Dir.getwd)
        working_directory app_root

        # workers + the master process
        sinatra_env = ENV['RACK_ENV']||'development'
        worker_processes(sinatra_env.to_s.downcase == 'production' ? 8 : 4)

        log_dir = File.expand_path(File.join(app_root, 'log'))
        unless Dir.exist?(log_dir)
          FileUtils.mkdir_p log_dir
        end
        log_file = File.expand_path(File.join(log_dir, "joke_server_#{sinatra_env}.log"))
        stderr_path log_file
        stdout_path log_file

 * Re-run the app

        unicorn -E ${RACK_ENV:-development} --config=./unicorn.rb --port=${PORT:-5000}

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
                status 500 # Internal Server Error
                json({service: 'healthCheck', error: 'Internal Server Error'})
                logger.error "File #{store_file} doesn't exist"
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

## Step 7 : Add redis as datastore an d connection pool

 * Update Gemfile

        source 'https://rubygems.org'

        ruby '2.1.2'

        gem 'bundler'
        gem 'unicorn'
        gem 'sinatra'#, require: 'sinatra/base'
        gem 'sinatra-contrib'
        gem 'hiredis'
        gem 'redis', require: %w(redis/connection/hiredis redis)
        gem 'connection_pool'

 * Create a connectionPool with Redis before JokeServer Class

        require 'connection_pool'

        ## Redis over ConnectionPool
        $redis ||= ::ConnectionPool.new(size: 4, timeout: 60) do
          url = URI('redis://localhost:6379/0')
          Redis.new(host: url.host, port: url.port, driver: :hiredis, db: 0)
        end

 * Run bundle install

        bundle install

 * Create joke_store model: models/joke_store.rb and require it in joke_server.rb

        ...

 * Update /healthCheck and /joke - Add POST:/joke for joke create