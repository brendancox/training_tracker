class AddWorkoutComponentIdToTemplateSet < ActiveRecord::Migration
  def change
    change_table :template_sets do |t|
      t.integer :workout_component_id
    end
  end
end
