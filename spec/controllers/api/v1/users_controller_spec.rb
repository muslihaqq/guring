# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'Users API', type: :request do
    let!(:user)            { create(:user) }
    let(:valid_params)     { { handle: user.handle } }
    let(:invalid_params)   { { handle: "wronghandle" } }
    let!(:token)           { JWT.encode({ user_id: user.id }, 's3cr3t') }

    describe 'GET /api/v1/users' do
      it "returns http success" do
        get '/api/v1/users'

        expect(response).to have_http_status(:success)
      end

      it "returns limited number of users" do
         get '/api/v1/users'

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["data"].length).to eq(4)
      end
    end

    describe 'POST api/v1/users/login' do
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

    describe "GET /api/v1/users/:id" do
      let!(:token) { JWT.encode({ user_id: user.id }, 's3cr3t') }
      let(:headers) { {authorization: "Bearer #{token}"}}
    
      context "when user exists" do
        before(:each) do
          create_list(:sleep_record, 10, user: user)
        end
    
        it "returns http success" do
          request.headers["Authorization"] = "Bearer #{token}"
          get "/api/v1/users/#{user.id}", headers: headers

          expect(response).to have_http_status(:success)
        end
    
        it "returns the user and their last week's records" do
          get "/api/v1/users/#{user.id}", headers: headers
          
          parsed_response = JSON.parse(response.body)
          expect(parsed_response["data"]["id"]).to eq(user.id)
          expect(parsed_response["last_week_records"].length).to eq(10)
        end
      end
    
      context "when user does not exist" do
        it "returns 404 error" do
          get "/api/v1/users/not_found", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end