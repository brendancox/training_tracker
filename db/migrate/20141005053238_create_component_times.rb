class CreateComponentTimes < ActiveRecord::Migration
  def change
    create_table :component_times do |t|
      t.integer :workout_id
      t.integer :meters
      t.integer :seconds

      t.timestamps
    end
  end
end
