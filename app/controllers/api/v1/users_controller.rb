# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: %i[login index]

  def index
    users = service.list_users
    pagy, results = pagy(users, items: limit)
    render_json_array results,
                      metadata: pagy_metadata(pagy)
  end

  def show
    last_week_records = user.last_week_records
    render_json user,
                UserOutput,
                use: :detail_format,
                last_week_records: last_week_records
  end

  def sleep_records
    sleep_records = service.sleep_records(user)
    pagy, results = pagy(sleep_records, items: limit)
    render_json_array results,
                      metadata: pagy_metadata(pagy)
  end

  def follow
    follow = service.follow(user)
    render_json follow,
                SuccessOutput,
                status: :created,
                message: "You are now following this user #{user.handle}"
  end

  def unfollow
    follow = service.unfollow(user)
    render_json follow,
                SuccessOutput,
                status: :created,
                message: "Successfully unfollowed #{user.handle}"
  end

  def login
    user_login = service.login(params[:handle])
    token = encode_token({ user_id: user_login.id })
    render_json user_login,
                UserOutput,
                token: token,
                use: :login_format
  end

  private

  def service
    UserService.new(current_user)
  end

  def user
    @user = User.find(params[:id])
  end
end
