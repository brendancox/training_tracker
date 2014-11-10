class ChangeDefaultOnCompletedInWorkouts < ActiveRecord::Migration
  def change
  	change_column :workouts, :completed, :boolean, default: :true
  end
end
