require_relative '../test_helper'
require_relative '../../models/joke'

class JokeTest < Test::Unit::TestCase
  def setup
    Ohm.redis.call('FLUSHALL')
    [{joke: 'First'}, {joke: 'Second'}, {joke: 'Third'}].each do |j|
      Joke.create(j)
    end
  end

  def teardown
    Ohm.redis.call('FLUSHALL')
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
