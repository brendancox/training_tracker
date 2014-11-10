class ComponentTime < ActiveRecord::Base
  belongs_to :workout
  belongs_to :workout_component
end
