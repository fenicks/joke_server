require_relative '../test_helper'
require_relative '../../models/joke'

class JokeTest < Test::Unit::TestCase
  def setup
    Ohm.redis.call('flushall')
    # [{joke: 'First'}, {joke: 'Second'}, {joke: 'Third'}].each do |j|
    #   Joke.create(j)
    # end
  end

  def teardown
    Ohm.redis.call('flushall')
  end

  def test_joke_v1
    get '/v1/joke'
    assert last_response.ok?
    assert_not_nil last_response.body
  end

  def test_joke_v2
    get '/v2/joke'
    assert last_response.ok?
    assert_not_nil last_response.body

    post '/v2/joke', {joke: 'First'}
    assert last_response.ok?
    assert_not_nil last_response.body

    patch '/v2/joke/1', {joke: 'First updated'}
    assert last_response.ok?
    assert_not_nil last_response.body
    j = Joke.with(:joke, 'First updated')
    assert_equal 'First updated', j.joke


    delete '/v2/joke/1'
    assert last_response.ok?
    assert_not_nil last_response.body
    j = Joke.with(:joke, 'First updated')
    assert_nil j
  end
end
