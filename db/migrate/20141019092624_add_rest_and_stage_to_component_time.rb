class AddRestAndStageToComponentTime < ActiveRecord::Migration
  def change
    change_table :component_times do |t|
      t.integer :rest
      t.string :stage
    end
  end
end
