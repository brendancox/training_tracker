class AlterColumnsInWorkoutTables < ActiveRecord::Migration
  def change
  	remove_column :recorded_workouts, :workout_time
  	add_column :recorded_workouts, :name, :string
  	add_column :recorded_workouts, :workout_date, :date
  	add_column :recorded_workouts, :workout_time, :string

  	remove_column :scheduled_workouts, :workout_time
  	add_column :scheduled_workouts, :name, :string
  	add_column :scheduled_workouts, :workout_date, :date
  	add_column :scheduled_workouts, :workout_time, :string

  	add_column :templates, :name, :string
  end
end
