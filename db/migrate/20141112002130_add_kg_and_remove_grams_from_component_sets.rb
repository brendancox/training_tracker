class AddKgAndRemoveGramsFromComponentSets < ActiveRecord::Migration
  def change
  	add_column :component_sets, :kg, :float
  	remove_column :component_sets, :grams
  end
end
