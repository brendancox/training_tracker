class AddWorkoutComponentIdToTemplateTime < ActiveRecord::Migration
  def change
    change_table :template_times do |t|
      t.integer :workout_component_id
    end
  end
end
