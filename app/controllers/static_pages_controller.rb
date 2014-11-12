class StaticPagesController < ApplicationController

  def home
  	@workouts = Workout.all
  	@templates = Template.all
  	@recent_scheduled = Workout.recent_scheduled
  end

end
