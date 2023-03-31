class Api::V1::UsersController < ApplicationController
  def index
    @users = User.all.limit(5)
    json_response({data: @users})
  end

  def show
    @one_week_records = @user.last_week_records
    json_response({
      data: @user,
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
end
                                          