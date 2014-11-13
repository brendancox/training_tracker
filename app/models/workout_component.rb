class WorkoutComponent < ActiveRecord::Base
  has_many :component_sets
  has_many :component_times
  has_many :template_sets
  has_many :template_times
  has_many :scheduled_sets
  has_many :scheduled_times
  belongs_to :user
end
