class AddWorkoutComponentIdToComponentTime < ActiveRecord::Migration
  def change
    change_table :component_times do |t|
      t.integer :workout_component_id
    end
  end
end
