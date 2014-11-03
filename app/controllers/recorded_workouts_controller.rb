class RecordedWorkoutsController < ApplicationController

  def index
    @workouts = RecordedWorkout.all
  end


  def new
    @workout = RecordedWorkout.new(params[:recorded_workout])

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
    @template_workout_times = Array.new
    @template_workout_sets = Array.new

    if params[:template].nil?
      num_of_time_components = time_components.count
      num_of_set_components = set_components.count
      @time_component_array.each do |time_component|
        @template_workout_times.push({workout_id: time_component[1]})
      end
      @set_component_array.each do |set_component|
        @template_workout_sets.push({workout_id: set_component[1]})
      end
    else
      template = Template.find(params[:template])
      template_time_group = template.template_times.all
      template_set_group = template.template_sets.all
      num_of_time_components = template_time_group.count
      num_of_set_components = template_set_group.count
      template_time_group.each do |exercise|
        @template_workout_times.push({workout_name: exercise.workout_component.name, 
                                      workout_id: exercise.workout_component.id,
                                      meters: exercise.meters, 
                                      seconds: exercise.seconds, 
                                      rest: exercise.rest, 
                                      stage: exercise.stage})
      end
      template_set_group.each do |exercise|
        @template_workout_sets.push({workout_name: exercise.workout_component.name, 
                                     workout_id: exercise.workout_component.id,
                                     kg: exercise.grams / 1000, 
                                     reps: exercise.reps, 
                                     num_of_sets: exercise.num_of_sets, 
                                     rest: exercise.rest, 
                                     stage: exercise.stage})
      end
    end
    params.permit(:recorded_workout, times: [], sets: [])
    @component_times = Array.new(num_of_time_components) {@workout.component_times.new(params[:times])}
    @component_sets = Array.new(num_of_set_components) {@workout.component_sets.new(params[:sets])}

  end

  def create
    workout_time = flatten_date(params[:recorded_workout])
    puts "DEBUG OUTPUT BELOW"
    puts workout_time
    this_workout = RecordedWorkout.create(workout_time: workout_time)

    time_params = params[:recorded_workout][:times]
    time_params.each do |time_param|
      unless time_param[:meters].empty? && time_param[:seconds].empty?
        this_workout.component_times.create(
                              meters: time_param[:meters],
                              seconds: time_param[:seconds],
                              workout_component_id: time_param[:workout_component_id],
                              rest: time_param[:rest])
      end
    end
    set_params = params[:recorded_workout][:sets]
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
    redirect_to recorded_workout_url(this_workout)
  end

  def show
    @this_workout = RecordedWorkout.find(params[:id])

  end

  def destroy
    @workout = RecordedWorkout.find(params[:id])
    @workout.destroy

    respond_to do |format|
      format.js { render :layout => false }
      format.html {redirect_to recorded_workouts_url}
    end
  end

  private

  def flatten_date(parent_param)

    Time.new(parent_param["workout_time(1i)"],
             parent_param["workout_time(2i)"],
             parent_param["workout_time(3i)"],
             parent_param["workout_time(4i)"],
             parent_param["workout_time(5i)"],
             parent_param["workout_time(6i)"],
             parent_param["workout_time(7i)"])
  end

end
