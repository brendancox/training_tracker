class ComponentSet < ActiveRecord::Base
  belongs_to :recorded_workout
  belongs_to :workout_component
end
