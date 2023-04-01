class CreateSleepRecords < ActiveRecord::Migration[7.0]
  def change
    unless table_exists? :sleep_records
      create_table :sleep_records do |t|
        t.datetime :clock_in
        t.datetime :clock_out
        t.references :user, null: false, foreign_key: true

        t.timestamps
      end
    end
  end
end
