class RemoveForces < ActiveRecord::Migration
  def change
  	drop_table :workout__forces
  end
end
