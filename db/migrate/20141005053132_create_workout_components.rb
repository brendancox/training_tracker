class CreateWorkoutComponents < ActiveRecord::Migration
  def change
    create_table :workout_components do |t|
      t.string :name
      t.string :component_type

      t.timestamps
    end
  end
end
