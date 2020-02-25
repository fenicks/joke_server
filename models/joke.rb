# frozen_string_literal: true
require 'ohm'
require 'ohm/timestamps'

class Joke < Ohm::Model
  include Ohm::Timestamps

  attribute :joke
  unique    :joke
  index     :joke
end
