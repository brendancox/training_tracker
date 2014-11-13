class AddUserIdToWorkoutComponent < ActiveRecord::Migration
  def change
  	add_column :workout_components, :user_id, :integer
  end
end
