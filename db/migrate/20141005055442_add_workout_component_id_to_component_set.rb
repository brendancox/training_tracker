class AddWorkoutComponentIdToComponentSet < ActiveRecord::Migration
  def change
    change_table :component_sets do |t|
      t.integer :workout_component_id
    end
  end
end
