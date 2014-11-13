class RemoveTimesEquipmentInWorkoutComponent < ActiveRecord::Migration
  def change
  	remove_column :workout_components, :times_equipment
  end
end
