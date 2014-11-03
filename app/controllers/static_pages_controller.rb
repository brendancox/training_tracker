class StaticPagesController < ApplicationController

  def home

  	@recorded_workouts = RecordedWorkout.all
  	@scheduled_workouts = ScheduledWorkout.all

  end

  def add_to_calendar

  end

end
