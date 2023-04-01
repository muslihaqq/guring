# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SleepRecordsController, type: :controller do
  describe 'Sleep records API', type: :request do
    let!(:user) { create(:user) }
    let(:auth_token) { JWT.encode({ user_id: user.id }, 's3cr3t') }
    let(:headers) { { authorization: "Bearer #{auth_token}" } }

    describe "GET /api/v1/sleep_records " do
      context "when user is authenticated" do
        before do
          create_list(:sleep_record, 3, user: user)
          get "/api/v1/sleep_records", headers: headers
        end

        it "returns a 200 response" do
          expect(response).to have_http_status(200)
        end

        it "returns only complete sleep records" do
          expect(response_body[:data].length).to eq(3)
        end
      end

      context "when user is not authenticated" do
        before { get "/api/v1/sleep_records" }

        it "returns a 401 response" do
          expect(response).to have_http_status(401)
        end
      end
    end

    describe "#clock_in" do
      context "when user is authenticated" do
        before do
          post "/api/v1/sleep_records/clock_in", headers: headers
        end

        it "returns a 201 response" do
          expect(response).to have_http_status(201)
        end

        it "returns a success message" do
          message = response_body[:data][:message]
          expect(message).to eq("Successfully clock in!")
        end
      end

      context "when user is not authenticated" do
        before { post "/api/v1/sleep_records/clock_in" }

        it "returns a 401 response" do
          expect(response).to have_http_status(401)
        end
      end
    end

    describe "#clock_out" do
      context "when user is authenticated and has incomplete sleep record" do
        let!(:sleep_record_incomplete) { create(:sleep_record_incomplete, user: user) }

        before do
          patch "/api/v1/sleep_records/clock_out", headers: headers
        end

        it "returns a 200 response" do
          expect(response).to have_http_status(200)
        end

        it "returns a success message" do
          message = response_body[:data][:message]
          expect(message).to eq("Successfully clock out!")
        end
      end

      context "when user is not authenticated" do
        before { patch "/api/v1/sleep_records/clock_out" }

        it "returns a 401 response" do
          expect(response).to have_http_status(401)
        end
      end

      context "when user is authenticated but has no incomplete sleep record" do
        before do
          create(:sleep_record, user: user)
          patch "/api/v1/sleep_records/clock_out", headers: headers
        end

        it "returns a 404 response" do
          expect(response).to have_http_status(404)
        end

        it "returns an error message" do
          error = response_body[:error]
          expect(error).to eq("Theres no incomplete record")
        end
      end
    end
  end
end
