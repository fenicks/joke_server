require_relative '../test_helper'
require_relative '../../models/joke'

class JokeTest < Test::Unit::TestCase
  def setup
    Ohm.redis.call('FLUSHALL')
  end

  def teardown
    Ohm.redis.call('FLUSHALL')
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

    post '/v2/joke', {joke: 'The first'}
    assert last_response.ok?
    assert_not_nil last_response.body

    str_updated = 'The first updated'

    patch '/v2/joke/1', {joke: str_updated}
    assert last_response.ok?
    assert_not_nil last_response.body
    j = Joke.with(:joke, str_updated)
    assert_equal str_updated, j.joke


    delete '/v2/joke/1'
    assert last_response.ok?
    assert_not_nil last_response.body
    j = Joke.with(:joke, str_updated)
    assert_nil j
  end
end
