class WorkoutComponentsController < ApplicationController

  before_action :authenticate_user!
  
  def new
    @workout_component = WorkoutComponent.new(params[:workout_component])
    @templates = current_user.templates.all
  end

  def create
    workout_component = WorkoutComponent.create(name: params[:workout_component][:name],
                            component_type: params[:workout_component][:component_type])
    redirect_to workout_component_url(workout_component)
  end

  def show
    @workout_component = WorkoutComponent.find(params[:id])
    @templates = current_user.templates.all
  end

end
