# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::Api::V1::UsersController, type: :controller do
  describe 'Users API', type: :request do
    let!(:user)           { create(:user) }
    let(:valid_params)    {{handle: user.handle}}
    let(:invalid_params)  { {handle: "wronghandle"}}

    describe 'POST /login' do
      context 'when params is valid' do 
        it 'should not returns error message' do
          post "/api/v1/users/login", params: valid_params

          expect(response.status).to eq(200)
         
          expect(JSON.parse(response.body)['data']).to eq(user.as_json)
          expect(JSON.parse(response.body)['token']).to_not eq(nil)
          expect(JSON.parse(response.body)['error']).to eq(nil)
        end
      end

      context 'when params is invalid' do 
        it 'returns error message' do
          post "/api/v1/users/login", params: invalid_params

          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)['user']).to eq(nil)
          expect(JSON.parse(response.body)['token']).to eq(nil)
          expect(JSON.parse(response.body)['error']).to_not eq(nil)
        end
      end

    end
  end
end