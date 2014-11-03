class WorkoutsController < ApplicationController

  def new
  	generate_component_arrays 
    @template_workout_times = Array.new
    @template_workout_sets = Array.new

    if params[:template].nil?
      set_template_arrays_to_default
    else
      load_template_arrays
    end

    load_arrays_for_new_workout_form
  end

  private

  def flatten_date(parent_param)

    Time.new(parent_param["workout_time(1i)"],
             parent_param["workout_time(2i)"],
             parent_param["workout_time(3i)"],
             parent_param["workout_time(4i)"],
             parent_param["workout_time(5i)"])
  end

  def generate_component_arrays
    #initialize arrays to help form the exercise select boxes
    time_components = WorkoutComponent.where(component_type: "Time")
    @time_component_array = Array.new
    time_components.each do |time_component|
      @time_component_array.push([time_component.name, time_component.id])
    end
    set_components = WorkoutComponent.where(component_type: "Reps")
    @set_component_array = Array.new
    set_components.each do |set_component|
      @set_component_array.push([set_component.name, set_component.id])
    end
  end

  def set_template_arrays_to_default
    #match template arrays to component arrays
    @time_component_array.each do |time_component|
      @template_workout_times.push({workout_id: time_component[1]})
    end
    @set_component_array.each do |set_component|
      @template_workout_sets.push({workout_id: set_component[1]})
    end
  end

  def load_template_arrays
    template = Template.find(params[:template])
    template.component_times.each do |exercise|
      @template_workout_times.push({workout_name: exercise.workout_component.name, 
                                    workout_id: exercise.workout_component.id,
                                    meters: exercise.meters, 
                                    seconds: exercise.seconds, 
                                    rest: exercise.rest, 
                                    stage: exercise.stage})
    end
    template.component_sets.each do |exercise|
      @template_workout_sets.push({workout_name: exercise.workout_component.name, 
                                   workout_id: exercise.workout_component.id,
                                   kg: exercise.grams / 1000, 
                                   reps: exercise.reps, 
                                   num_of_sets: exercise.num_of_sets, 
                                   rest: exercise.rest, 
                                   stage: exercise.stage})
    end
  end

  def load_arrays_for_new_workout_form
    params.permit(:recorded_workout, times: [], sets: [])
    @component_times = Array.new(@template_workout_times.count) {@workout.component_times.new(params[:times])}
    @component_sets = Array.new(@template_workout_sets.count) {@workout.component_sets.new(params[:sets])}
  end

  def save_component_times(this_workout, time_params)
    time_params.each do |time_param|
      unless time_param[:meters].empty? && time_param[:seconds].empty?
        this_workout.component_times.create(
                              meters: time_param[:meters],
                              seconds: time_param[:seconds],
                              workout_component_id: time_param[:workout_component_id],
                              rest: time_param[:rest])
      end
    end
  end

  def save_component_sets(this_workout, set_params)
    set_params.each do |set_param|
      unless set_param[:reps].empty?
        grams = set_param[:grams].to_i * 1000 unless set_param[:grams].empty?
        this_workout.component_sets.create(
                              grams: grams,
                              reps: set_param[:reps],
                              workout_component_id: set_param[:workout_component_id],
                              num_of_sets: set_param[:num_of_sets],
                              rest: set_param[:rest])
      end
    end
  end
end
