class AddSleepTimeToSleepRecord < ActiveRecord::Migration[7.0]
  def change
    add_column :sleep_records, :sleep_time, :float
  end
end
