# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  belongs_to :user

  scope :incomplete, -> { where.not(clock_in: nil).where(clock_out: nil) }
  scope :complete, -> { where.not(clock_in: nil, clock_out: nil).order('created_at DESC') }
  scope :last_week, lambda { |user_id|
    complete.reorder(nil)
            .where(user_id: user_id, clock_in: 1.week.ago.beginning_of_day..)
            .order('sleep_time DESC')
  }

  before_update :calculate_sleep_time

  private

  def calculate_sleep_time
    self.sleep_time = clock_out - clock_in
  end
end
