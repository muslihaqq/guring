class UserService < ApplicationService
  def initialize(current_user = nil)
    @current_user = current_user
  end

  def list_users
    User.all.limit(5)
  end

  def sleep_records(user)
    not_follow = @current_user.not_following?(user)
    assert!(not_follow, on_error: "You need to follow this user to see their sleep records")

    user.sleep_records
  end

  def follow(user)
    already_followed = @current_user.following?(user)
    assert!(already_followed, on_error: "You are already following this user")

    @current_user.follow(user)
  end

  def unfollow(user)
    not_following = @current_user.not_following?(user)
    assert!(not_following, on_error: "#{user.handle} is not being followed")

    @current_user.unfollow(user)
  end

  def login(user_handle)
    user = User.find_by(handle: user_handle)
    authorize!(user, on_error: "Login: Invalid user handle")

    user
  end
end
