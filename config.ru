# frozen_string_literal: true
require 'bundler/setup'
Bundler.setup

require_relative 'joke_server'

run JokeServer.new
