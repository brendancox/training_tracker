class AddOrderToComponents < ActiveRecord::Migration
  def change
  	add_column :component_sets, :order, :integer
  	add_column :component_times, :order, :integer
  end
end
