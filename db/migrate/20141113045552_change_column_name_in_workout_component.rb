class ChangeColumnNameInWorkoutComponent < ActiveRecord::Migration
  def change
  	rename_column :workout_components, :reps_equipment, :reps_equipment
  	remove_column :workout_components, :sets_equipment
  end
end
