# frozen_string_literal: true

class SleepRecordService < ApplicationService
  def initialize(user)
    super()
    @user = user
  end

  def sleep_records
    @user.sleep_records.complete
  end

  def clock_in
    @user.clock_in!
  end

  def clock_out
    incomplete_clock_out = @user.sleep_records.incomplete.last
    exist!(incomplete_clock_out, on_error: 'Theres no incomplete record')

    @user.clock_out!
  end
end
