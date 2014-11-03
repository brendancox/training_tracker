class ChangeTableNameWorkouts < ActiveRecord::Migration
  def change
  	rename_table :workouts, :recorded_workouts
  end
end
