# frozen_string_literal: true
require_relative '../../spec_helper'
require_relative '../../../models/joke'

describe 'Integration/Model: Joke test' do
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

  it 'should create jokes' do
    %w(JokeModelTestFirst JokeModelTestSecond JokeModelTestThird).each do |d|
      j = Joke.with(:joke, d)
      j.save

      t = Joke[j.id]
      expect(t).to be_an_instance_of(Joke)
      expect(t).not_to be_nil
      expect(t.joke).to eq(d)
    end
  end

  it 'should update joke' do
    third = 'JokeModelTestThird'
    j = Joke.with(:joke, third)
    expect(j.joke).to eq(third)

    third_updated = 'JokeModelTestThird updated'
    j = Joke[j.id]
    j.update joke: third_updated
    expect(j.joke).to eq(third_updated)

    j = Joke.with(:joke, third_updated)
    j.update joke: third
  end

  it 'should delete joke' do
    third = 'JokeModelTestThird'
    j = Joke.with(:joke, third)

    j.delete
    j = Joke.with(:joke, third)
    expect(j).to be_nil

    Joke.create(joke: third)
  end
end
