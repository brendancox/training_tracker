class DropRecordedAndScheduledTables < ActiveRecord::Migration
  def change
  	drop_table :recorded_workouts
  	drop_table :scheduled_workouts
  end
end
