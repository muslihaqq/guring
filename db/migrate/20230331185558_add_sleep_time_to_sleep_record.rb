class AddSleepTimeToSleepRecord < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:sleep_records, :sleep_time)
      add_column :sleep_records, :sleep_time, :float
    end
  end
end
