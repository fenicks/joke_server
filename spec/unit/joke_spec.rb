# frozen_string_literal: true
require_relative '../spec_helper'
require_relative '../../models/joke'

describe 'Unit test for /joke' do
  before(:all) do
    Ohm.redis.call('FLUSHDB')
    [{ joke: 'JokeModelTestFirst' },
     { joke: 'JokeModelTestSecond' },
     { joke: 'JokeModelTestThird' }].each do |j|
      Joke.create j
    end
  end

  after(:all) do
    Ohm.redis.call('FLUSHDB')
  end

  describe 'API version 1: /v1' do
    it 'should respond to /v1/joke' do
      get '/v1/joke'
      expect(last_response).to be_ok
      expect(last_response.body).not_to be_empty
    end
  end

  describe 'API version 2: /v2' do
    it 'should respond to /v2/joke' do
      get '/v2/joke'
      expect(last_response).to be_ok
      expect(last_response.body).not_to be_empty
    end

    it 'should create a joke' do
      post '/v2/joke', joke: 'JokeTestFourth'
      expect(last_response).to be_ok
      expect(last_response.body).not_to be_empty
    end

    it 'should update the joke' do
      str_updated = 'JokeTestFourth updated'

      patch '/v2/joke/1', joke: str_updated
      expect(last_response).to be_ok
      expect(last_response.body).not_to be_empty

      j = Joke.with(:joke, str_updated)
      expect(j.joke).to eq(str_updated)
    end

    it 'should delete the joke' do
      delete '/v2/joke/1'
      expect(Joke[1]).to be_nil
    end
  end
end
