class ComponentTimesController < ApplicationController

  def new
  end

  def create
    redirect_to workouts_url
  end

end
