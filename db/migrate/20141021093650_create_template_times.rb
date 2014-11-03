class CreateTemplateTimes < ActiveRecord::Migration
  def change
    create_table :template_times do |t|
      t.integer :template_id
      t.integer :meters
      t.integer :seconds
      t.integer :rest
      t.string :stage

      t.timestamps
    end
  end
end
