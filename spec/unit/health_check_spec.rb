# frozen_string_literal: true
require_relative '../spec_helper'

describe 'Unit test for /healthCheck' do
  describe 'API version 1: /v1' do
    it 'should respond to /v1/healthCheck' do
      get '/v1/healthCheck'
      expect(last_response).to be_ok
      expect(last_response.body).not_to be_empty
    end
  end

  describe 'API version 2: /v2' do
    it 'should respond to /v2/healthCheck' do
      get '/v2/healthCheck'
      expect(last_response).to be_ok
      expect(last_response.body).not_to be_empty
    end
  end
end
