# frozen_string_literal: true
require_relative '../spec_helper'

describe 'Unit test for /hi' do
  it 'should respond to /hi' do
    get '/hi'
    expect(last_response).to be_ok
    expect(last_response.body).not_to be_empty
  end
end
