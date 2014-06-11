require_relative '../test_helper'

class HealthCheckTest < Test::Unit::TestCase
  def test_health_check_v1
    get '/v1/healthCheck'
    assert last_response.ok?
    assert_not_nil last_response.body
  end

  def test_health_check_v2
    get '/v2/healthCheck'
    assert last_response.ok?
    assert_not_nil last_response.body
  end
end
