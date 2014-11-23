class ComponentSet < ActiveRecord::Base
  belongs_to :workout
  belongs_to :workout_component
  validates :workout_component_id, presence: :true
  validates :workout_id, presence: :true
end
