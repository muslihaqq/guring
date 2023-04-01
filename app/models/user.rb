class User < ApplicationRecord
  has_many :sleep_records

  has_many :active_relationships,  class_name:  "Follow",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Follow",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def clock_in!
    sleep_records.create(clock_in: DateTime.now)
  end

  def clock_out!
    return false if sleep_records.incomplete.nil?

    sleep_records.incomplete.last.update(clock_out: DateTime.now)
  end

  def last_week_records
    SleepRecord.last_week(id)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
