class StaticPagesController < ApplicationController

  def home
  	@workouts = Workout.all
  	@templates = Template.all
  	@recent_scheduled = Array.new
  	@workouts.each do |workout|
  		if workout.workout_date < Date.today && workout.completed == false
  			@recent_scheduled.push(workout)
  			break if @recent_scheduled.length > 5 
  		end
  	end
  end

end
