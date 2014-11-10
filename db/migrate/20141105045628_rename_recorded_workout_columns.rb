class RenameRecordedWorkoutColumns < ActiveRecord::Migration
  def change
  	rename_column :component_sets, :recorded_workout_id, :workout_id
  	rename_column :component_times, :recorded_workout_id, :workout_id
  end
end
