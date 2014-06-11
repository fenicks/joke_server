require 'ohm'
require 'ohm/contrib'

class Joke < Ohm::Model
  include Ohm::Timestamps

  attribute :joke
  unique    :joke
end