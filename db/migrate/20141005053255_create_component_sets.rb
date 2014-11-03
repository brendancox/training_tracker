class CreateComponentSets < ActiveRecord::Migration
  def change
    create_table :component_sets do |t|
      t.integer :workout_id
      t.integer :grams
      t.integer :reps

      t.timestamps
    end
  end
end
