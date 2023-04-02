require 'pagy/extras/metadata'

class ApplicationController < ActionController::API
  include Response
  include Pagy::Backend
  include ExceptionHandler

  before_action :authorized

  private

  def encode_token(payload)
    JWT.encode(payload, 's3cr3t')
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @current_user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def default_output
    ApiOutput
  end

  def render_json(model, klass = default_output, **options)
    status = options[:status] || :ok
    method = options[:use] || :format
    output = klass.new(model, **options).send(method)
    render json: { data: output }, status: status
  end

  def render_json_array(model, klass = default_output, **options)
    status = options[:status] || :ok
    method = options[:use] || :format
    metadata = metadata(options[:metadata])
    output = klass.new(model, **options).send(method)
    render json: { data: output, metadata: metadata }, status: status
  end

  def metadata(options)
    {
      prev_page: options[:prev],
      current_page: options[:page],
      next_page: options[:next],
    }
  end

  def limit
    params[:limit] || 25
  end
end
