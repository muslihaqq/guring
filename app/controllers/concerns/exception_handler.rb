# frozen_string_literal: true

module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  Invalid = Class.new(StandardError)
  NotAuthorized = Class.new(StandardError)

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e.message }, status: :not_found
    end

    rescue_from ApplicationController::Invalid do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end

    rescue_from ApplicationController::NotAuthorized do |e|
      render json: { error: e.message }, status: :unauthorized
    end
  end
end
