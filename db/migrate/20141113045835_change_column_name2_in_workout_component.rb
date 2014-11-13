class ChangeColumnName2InWorkoutComponent < ActiveRecord::Migration
  def change
  	rename_column :workout_components, :reps_equipment, :equipment
  end
end
