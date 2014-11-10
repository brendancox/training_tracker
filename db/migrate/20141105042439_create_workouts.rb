class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.string :name
      t.date :workout_date
      t.string :workout_time
      t.text :notes
      t.integer :template_id
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
