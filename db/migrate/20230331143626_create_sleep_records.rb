class CreateSleepRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_records do |t|
      t.datetime :clock_in
      t.datetime :clock_out
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
