class StaticPagesController < ApplicationController

  def home
  	if user_signed_in?
	  @workouts = current_user.workouts.all
	  @templates = current_user.templates.all
	  @recent_scheduled = @workouts.recent_scheduled
  	else
  	  @workouts = []
  	  @templates = []
  	  @recent_scheduled = []
  	end
  end

end
