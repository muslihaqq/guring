class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:login, :index]
  before_action :selected_user, only: [:show]
  
  def index
    @users = User.all.limit(5)
    json_response({data: @users})
  end

  def show
    return json_response(
      { message: "User not found" }, :not_found
    ) unless @selected_user

    @one_week_records = @selected_user&.last_week_records
    json_response({
      params: params[:id],
      data: @selected_user,
      last_week_records: @one_week_records
    })
  end

  def login
    @user = User.find_by(handle: params[:handle])

    if @user
      token = encode_token({ user_id: @user.id })

      json_response({
        data: @user,
        token: token
      })
    else
      json_response({
        error: "Login: Invalid user handle"
      }, :unauthorized)
    end
  end
  
  private
  
  def selected_user
    @selected_user = User.find_by_id(params[:id])
  end
end
                                          