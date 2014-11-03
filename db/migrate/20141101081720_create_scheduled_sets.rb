class CreateScheduledSets < ActiveRecord::Migration
  def change
    create_table :scheduled_sets do |t|
      t.integer :scheduled_workout_id
      t.integer :grams
      t.integer :reps
      t.integer :num_of_sets
      t.integer :rest
      t.string :stage
      t.integer :workout_component_id

      t.timestamps
    end
  end
end
