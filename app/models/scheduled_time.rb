class ScheduledTime < ActiveRecord::Base
  belongs_to :scheduled_workout
  belongs_to :workout_component
end
