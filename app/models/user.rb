class User < ApplicationRecord
  has_many :sleep_records

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
end
