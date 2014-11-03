class TemplatesController < ApplicationController

  def index
    @templates = Template.all
  end


  def new

    @template = Template.new(params[:template])
    time_components = WorkoutComponent.where(component_type: "Time")
    num_of_time_components = time_components.count
    @time_component_array = Array.new
    time_components.each do |time_component|
      @time_component_array.push([time_component.name, time_component.id])
    end

    set_components = WorkoutComponent.where(component_type: "Reps")
    num_of_set_components = set_components.count
    @set_component_array = Array.new
    set_components.each do |set_component|
      @set_component_array.push([set_component.name, set_component.id])
    end

    params.permit(:workout, times: [], sets: [])
    @template_times = Array.new(num_of_time_components) {@template.component_times.new(params[:times])}
    @template_sets = Array.new(num_of_set_components) {@template.component_sets.new(params[:sets])}

  end

  def create
    this_template = Template.create()
    time_params = params[:template][:times]
    time_params.each do |time_param|
      unless time_param[:meters].empty? && time_param[:seconds].empty?
        this_template.component_times.create(
                              meters: time_param[:meters],
                              seconds: time_param[:seconds],
                              workout_component_id: time_param[:workout_component_id],
                              rest: time_param[:rest])
      end
    end
    set_params = params[:template][:sets]
    set_params.each do |set_param|
      unless set_param[:reps].empty?
        grams = set_param[:grams].to_i * 1000 unless set_param[:grams].empty?
        this_template.component_sets.create(
                              grams: grams,
                              reps: set_param[:reps],
                              workout_component_id: set_param[:workout_component_id],
                              num_of_sets: set_param[:num_of_sets],
                              rest: set_param[:rest])
      end
    end
    redirect_to template_url(this_template)
  end

  def show
    @this_template = Template.find(params[:id])

  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy

    respond_to do |format|
      format.js { render :layout => false }
      format.html {redirect_to templates_url}
    end
  end
end
