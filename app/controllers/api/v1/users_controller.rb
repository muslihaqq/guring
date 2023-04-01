class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:login, :index]
  before_action :set_user, only: [:show, :follow, :unfollow]
  
  def index
    @users = User.all.limit(5)
    json_response({data: @users})
  end

  def show
    return json_response(
      { message: "User not found" }, :not_found
    ) unless @user

    @one_week_records = @user&.last_week_records
    json_response({
      params: params[:id],
      data: @user,
      last_week_records: @one_week_records
    })
  end

  def follow
    if current_user.following.include?(@user)
      json_response({error: "You are already following this user"}, :unprocessable_entity)
  elsif current_user.follow(@user)
      json_response({data: "You are now following this user"})
    else
      json_response({error: "Failed to follow #{@user.name}"}, :unprocessable_entity)
    end
  end

  def unfollow
    if !current_user.following?(@user)
      json_response({error: "#{@user.name} is not being followed"}, :unprocessable_entity)
    elsif current_user.unfollow(@user)
      json_response({error: "Successfully unfollowed #{@user.name}"}, :ok)
    else
      json_response({error: "Failed to unfollow #{@user.name}"}, :unprocessable_entity)
    end
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
  
  def set_user
    @user = User.find(params[:id])
  end
end
                                          