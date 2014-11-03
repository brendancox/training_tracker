class LinkComponentSetTimesToScheduledTemplate < ActiveRecord::Migration
  def change
  	add_column :component_sets, :scheduled_workout_id, :integer
  	add_column :component_times, :scheduled_workout_id, :integer
  	add_column :component_sets, :template_id, :integer
  	add_column :component_times, :template_id, :integer
  	drop_table :scheduled_sets
  	drop_table :scheduled_times
  	drop_table :template_sets
  	drop_table :template_times
  end
end
