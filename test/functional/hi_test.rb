require_relative '../test_helper'

class HiTest < Test::Unit::TestCase
  def test_hi
    get '/hi'
    assert last_response.ok?
    assert_not_nil last_response.body
  end
end
