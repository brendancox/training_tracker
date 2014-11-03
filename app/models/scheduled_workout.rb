class ScheduledWorkout < ActiveRecord::Base
  has_many :scheduled_sets, :dependent => :destroy
  has_many :scheduled_times, :dependent => :destroy
  accepts_nested_attributes_for :scheduled_sets
  accepts_nested_attributes_for :scheduled_times
end
