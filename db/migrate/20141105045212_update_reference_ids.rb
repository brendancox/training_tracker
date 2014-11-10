class UpdateReferenceIds < ActiveRecord::Migration
  def change
  	rename_column :component_sets, :recorded_workout_id, :recorded_workout_id
  	rename_column :component_times, :recorded_workout_id, :recorded_workout_id
  	remove_column :component_sets, :scheduled_workout_id
  	remove_column :component_times, :scheduled_workout_id
  end
end
