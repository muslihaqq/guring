# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'Users API', type: :request do
    let!(:user)            { create(:user) }
    let(:valid_params)     { { handle: user.handle } }
    let(:invalid_params)   { { handle: 'wronghandle' } }

    describe 'GET /api/v1/users' do
      it 'returns http success' do
        get '/api/v1/users'
        expect(response).to have_http_status(:success)
      end

      it 'returns limited number of users' do
        get '/api/v1/users'
        expect(response_body[:data].length).to eq(1)
      end

      it 'returns http success with pagination' do
        15.times { create(:user) }
        get '/api/v1/users',
            params: { page: 3, limit: 5 },
            headers: headers
        expect(response).to have_http_status(:success)
        expect(response_body[:data].length).to eq(5)
        expect(response_body[:metadata][:prev_page]).to eq(2)
        expect(response_body[:metadata][:current_page]).to eq(3)
        expect(response_body[:metadata][:next_page]).to eq(4)
      end
    end

    describe 'GET /api/v1/users/:id/sleep_records' do
      let(:current_user)    { create(:user) }
      let(:target_user)     { create(:user) }
      let(:token)           { JWT.encode({ user_id: current_user.id }, 's3cr3t') }
      let(:headers)         { { authorization: "Bearer #{token}" } }

      context 'when user is authorized and following the target user' do
        before do
          allow(controller).to receive(:current_user).and_return(current_user)
          current_user.follow(target_user)
        end

        it 'returns HTTP status 200' do
          get "/api/v1/users/#{target_user.id}/sleep_records", headers: headers
          expect(response).to have_http_status(200)
        end

        it 'returns the sleep records of the target user' do
          sleep_record1 = create(:sleep_record, user: target_user)
          sleep_record2 = create(:sleep_record, user: target_user)

          get "/api/v1/users/#{target_user.id}/sleep_records", headers: headers
          expect(response_body[:data]).to be_an(Array)
          expect(response_body[:data].size).to eq(2)
          expect(response_body[:data][0][:id]).to eq(sleep_record1.id)
          expect(response_body[:data][1][:id]).to eq(sleep_record2.id)
        end
      end

      context "when user is not authorized to view the target user's sleep records" do
        before do
          allow(controller).to receive(:current_user).and_return(current_user)
        end

        it 'returns HTTP status 422' do
          get "/api/v1/users/#{target_user.id}/sleep_records", headers: headers
          expect(response).to have_http_status(422)
          expect(response_body[:error]).to eq('You need to follow this user to see their sleep records')
        end
      end

      context 'when the target user does not exist' do
        before do
          allow(controller).to receive(:current_user).and_return(current_user)
        end

        it 'returns an error message' do
          get '/api/v1/users/9999/sleep_records', headers: headers
          expect(response).to have_http_status(404)
          expect(response_body[:error]).to eq("Couldn't find User with 'id'=9999")
        end
      end
    end

    describe 'POST api/v1/users/login' do
      context 'when params is valid' do
        it 'should not returns error message' do
          post '/api/v1/users/login', params: valid_params
          expect(response).to have_http_status(200)
          expect(response_body[:error]).to eq(nil)
          expect(response_body[:data][:id]).to eq(user.id)
          expect(response_body[:data][:token]).to_not eq(nil)
        end
      end

      context 'when params is invalid' do
        it 'returns error message' do
          post '/api/v1/users/login', params: invalid_params
          expect(response).to have_http_status(401)
          expect(response_body[:data]).to eq(nil)
          expect(response_body[:error]).to eq('Login: Invalid user handle')
        end
      end
    end

    describe 'GET /api/v1/users/:id' do
      let(:token)           { JWT.encode({ user_id: user.id }, 's3cr3t') }
      let(:headers)         { { authorization: "Bearer #{token}" } }

      context 'when user exists' do
        before(:each) do
          create_list(:sleep_record, 10, user: user)
        end

        it 'returns http success' do
          request.headers['Authorization'] = "Bearer #{token}"
          get "/api/v1/users/#{user.id}", headers: headers
          expect(response).to have_http_status(:success)
        end

        it "returns the user and their last week's records" do
          get "/api/v1/users/#{user.id}", headers: headers
          expect(response_body[:data][:id]).to eq(user.id)
          expect(response_body[:data][:last_week_records].length).to eq(10)
        end
      end

      context 'when user does not exist' do
        it 'returns 404 error' do
          get '/api/v1/users/not_found', headers: headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'POST /api/v1/users/:id/follow' do
      let(:token)           { JWT.encode({ user_id: user.id }, 's3cr3t') }
      let(:headers)         { { authorization: "Bearer #{token}" } }
      let(:second_user)     { create(:user) }

      before do
        post "/api/v1/users/#{second_user.id}/follow", headers: headers
      end

      context 'when follow other user' do
        it 'returns a 201 response' do
          expect(response).to have_http_status(201)
        end

        it 'returns a success message' do
          message = response_body[:data][:message]
          expect(message).to eq(
            "You are now following this user #{second_user.handle}"
          )
        end
      end

      context 'when following a user already followed' do
        before do
          post "/api/v1/users/#{second_user.id}/follow", headers: headers
        end

        it 'returns a 422 response' do
          expect(response).to have_http_status(422)
        end

        it 'returns an error message' do
          error = response_body[:error]
          expect(error).to eq('You are already following this user')
        end
      end
    end

    describe 'DELETE /api/v1/users/:id/unfollow' do
      let(:token)           { JWT.encode({ user_id: user.id }, 's3cr3t') }
      let(:headers)         { { authorization: "Bearer #{token}" } }
      let(:second_user)     { create(:user) }

      context 'when unfollow a followed user' do
        before do
          post "/api/v1/users/#{second_user.id}/follow", headers: headers
          delete "/api/v1/users/#{second_user.id}/unfollow", headers: headers
        end

        it 'returns a 201 response' do
          expect(response).to have_http_status(201)
        end

        it 'returns a success message' do
          message = response_body[:data][:message]
          expect(message).to eq(
            "Successfully unfollowed #{second_user.handle}"
          )
        end
      end

      context 'when unfollow a user not being followed' do
        before do
          delete "/api/v1/users/#{second_user.id}/unfollow", headers: headers
        end

        it 'returns a 422 response' do
          expect(response).to have_http_status(422)
        end

        it 'returns an error message' do
          error = response_body[:error]
          expect(error).to eq("#{second_user.handle} is not being followed")
        end
      end
    end
  end
end
