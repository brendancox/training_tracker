class AddEquipmentIntensityToComponentTimesSets < ActiveRecord::Migration
  def change
  	add_column :component_sets, :intensity_plan, :string
  	add_column :component_times, :intensity_plan, :string
  	add_column :workout_components, :reps_equipment, :string
  	add_column :workout_components, :times_equipment, :string
  end
end
