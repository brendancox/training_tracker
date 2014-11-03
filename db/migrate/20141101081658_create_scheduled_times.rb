class CreateScheduledTimes < ActiveRecord::Migration
  def change
    create_table :scheduled_times do |t|
      t.integer :scheduled_workout_id
      t.integer :meters
      t.integer :seconds
      t.integer :rest
      t.string :stage
      t.integer :workout_component_id

      t.timestamps
    end
  end
end
