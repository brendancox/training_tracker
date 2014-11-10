class WorkoutsController < ApplicationController

  def index
    @workouts = Workout.all
  end

  def new
    @workout = Workout.new(params[:workout])
    @templates = Template.all
  	generate_component_arrays 
    @template_workout = Hash.new

    if params[:scheduled]
      load_template(Workout.find(params[:scheduled]))
    elsif params[:template]
      load_template(Template.find(params[:template]))
    else
      set_template_to_default
    end

    load_arrays_for_new_workout_form
  end

  def create
    this_workout = Workout.create(name: params[:workout][:name],
                                          workout_date: flatten_date(params[:workout]),
                                          workout_time: params[:workout][:workout_time],
                                          notes: params[:workout][:notes],
                                          completed: params[:workout][:completed])
    save_component_times(this_workout, params[:workout][:times])
    save_component_sets(this_workout, params[:workout][:sets])

    redirect_to workout_url(this_workout)
  end

  def edit
    @workout = Workout.find(params[:id])
    @templates = Template.all
    generate_component_arrays 
    @template_workout = Hash.new
    load_template(@workout)

    params.permit(:recorded_workout, times: [], sets: [])
    @component_times = @template_workout[:times]
    @component_sets = @template_workout[:sets]

  end

  def update
    @workout = Workout.find(params[:id])

    if @workout.update(params[:workout])
      redirect_to @workout
    else
      render 'edit'
    end
  end

  def show
    @this_workout = Workout.find(params[:id])
  end

  def destroy
    @workout = Workout.find(params[:id])
  	@workout.destroy

    respond_to do |format|
      format.js { render :layout => false }
      format.html {redirect_to root_path}
    end
  end

  def schedule_workouts
    @templates = Template.all
    @workouts = Workout.all
  end

  def save_schedule
    unless params[:scheduled].nil?
      new_workouts_array = params[:scheduled]
      templates = Template.all
      new_workouts_array.each do |workout|
        template_id = workout[1][:template_id].to_i
        date = workout[1][:start]
        this_template = templates.find(template_id)
        times = this_template.component_times
        sets = this_template.component_sets
        new_workout = Workout.create(name: this_template[:name],
                                            workout_date: date,
                                            notes: this_template[:notes],
                                            completed: false)
        save_component_times(new_workout, times)
        save_component_sets(new_workout, sets)
      end
    end

    repsonse = {response: 'success'}

    respond_to do |format|
      format.json {render json: repsonse.to_json}
    end
  end

  private

  def flatten_date(parent_param)

    Date.new(parent_param["workout_date(1i)"].to_i,
             parent_param["workout_date(2i)"].to_i,
             parent_param["workout_date(3i)"].to_i)
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

  def set_template_to_default
    #match template arrays to component arrays
    @template_workout[:times] = Array.new
    @template_workout[:sets] = Array.new
    @time_component_array.each do |time_component|
      @template_workout[:times].push({workout_id: time_component[1]})
    end
    @set_component_array.each do |set_component|
      @template_workout[:sets].push({workout_id: set_component[1]})
    end
  end

  def load_template(template)
    @template_workout[:workout_date] = template.workout_date if defined?(template.workout_date)
    @template_workout[:name] = template.name
    @template_workout[:notes] = template.notes
    @template_workout[:times] = Array.new
    @template_workout[:sets] = Array.new
    template.component_times.each do |exercise|
      @template_workout[:times].push({workout_name: exercise.workout_component.name, 
                                              workout_id: exercise.workout_component.id,
                                              meters: exercise.meters, 
                                              seconds: exercise.seconds, 
                                              rest: exercise.rest, 
                                              stage: exercise.stage})
    end
    template.component_sets.each do |exercise|
      kg = exercise.grams / 1000 unless exercise.grams.blank?
      @template_workout[:sets].push({workout_name: exercise.workout_component.name, 
                                             workout_id: exercise.workout_component.id,
                                             kg: kg, 
                                             reps: exercise.reps, 
                                             num_of_sets: exercise.num_of_sets, 
                                             rest: exercise.rest, 
                                             stage: exercise.stage})
    end
  end

  def load_arrays_for_new_workout_form
    params.permit(:recorded_workout, times: [], sets: [])
    @component_times = Array.new(@template_workout[:times].count) {@workout.component_times.new(params[:times])}
    @component_sets = Array.new(@template_workout[:sets].count) {@workout.component_sets.new(params[:sets])}
  end

  def save_component_times(this_workout, time_params)
    unless time_params.nil?
      time_params.each do |time_param|
        unless time_param[:meters].blank? && time_param[:seconds].blank?
          this_workout.component_times.create(
                                meters: time_param[:meters],
                                seconds: time_param[:seconds],
                                workout_component_id: time_param[:workout_component_id],
                                rest: time_param[:rest],
                                intensity_plan: time_param[:intensity_plan])
        end
      end
    end
  end

  def save_component_sets(this_workout, set_params)
    unless set_params.nil?
      set_params.each do |set_param|
        unless set_param[:reps].blank?
          grams = set_param[:grams].to_i * 1000 unless set_param[:grams].empty?
          this_workout.component_sets.create(
                                grams: grams,
                                reps: set_param[:reps],
                                workout_component_id: set_param[:workout_component_id],
                                num_of_sets: set_param[:num_of_sets],
                                rest: set_param[:rest],
                                intensity_plan: set_param[:intensity_plan])
        end
      end
    end
  end
end
