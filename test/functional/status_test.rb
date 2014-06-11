require_relative '../test_helper'

class StatusTest < Test::Unit::TestCase
  def test_status_v1
    get '/v1/status'
    assert last_response.ok?
    assert_not_nil last_response.body
  end
end
