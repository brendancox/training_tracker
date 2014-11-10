class CreateWorkoutForces < ActiveRecord::Migration
  def change
    create_table :workout__forces do |t|

      t.timestamps
    end
  end
end
