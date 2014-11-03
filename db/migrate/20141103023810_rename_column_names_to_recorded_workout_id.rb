class RenameColumnNamesToRecordedWorkoutId < ActiveRecord::Migration
  def change
  	rename_column :component_sets, :workout_id, :recorded_workout_id
  	rename_column :component_times, :workout_id, :recorded_workout_id
  end
end
