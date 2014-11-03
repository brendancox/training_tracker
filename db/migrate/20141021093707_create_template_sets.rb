class CreateTemplateSets < ActiveRecord::Migration
  def change
    create_table :template_sets do |t|
      t.integer :template_id
      t.integer :grams
      t.integer :reps
      t.integer :num_of_sets
      t.integer :rest
      t.string :stage

      t.timestamps
    end
  end
end
