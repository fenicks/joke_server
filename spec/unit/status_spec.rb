# frozen_string_literal: true
require_relative '../spec_helper'

describe 'Unit test for /status' do
  describe 'API version 1: /v1' do
    it 'should respond to /v1/status' do
      get '/v1/status'
      expect(last_response).to be_ok
      expect(last_response.body).not_to be_empty
    end
  end
end
