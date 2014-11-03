class AddNumOfSetsToComponentSet < ActiveRecord::Migration
  def change
    change_table :component_sets do |t|
      t.integer :num_of_sets
      t.integer :rest
      t.string :stage
    end
  end
end
