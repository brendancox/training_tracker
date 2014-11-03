class CreateScheduledWorkouts < ActiveRecord::Migration
  def change
    create_table :scheduled_workouts do |t|
      t.datetime :workout_time
      t.text :notes
      t.integer :template_id

      t.timestamps
    end
  end
end
