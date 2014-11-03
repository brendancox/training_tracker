class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.datetime :workout_time
      t.text :notes

      t.timestamps
    end
  end
end
