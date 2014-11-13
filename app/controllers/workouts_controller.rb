class WorkoutsController < ApplicationController

  before_action :authenticate_user!

  def index
    @workouts = current_user.workouts.all
    @templates = current_user.templates.all
  end

  def new
    @templates = current_user.templates.all
  	generate_component_arrays 
    @workout = Workout.new(params[:workout])
    if params[:template]
      load_template(current_user.templates.find(params[:template]), true)
    else
      set_template_to_default
    end
    @workout.workout_date = params[:date] if params[:date]
  end

  def create
    this_workout = Workout.create(workout_params)
    redirect_to workout_url(this_workout)
  end

  def edit
    @workout = current_user.workouts.find(params[:id])
    @templates = current_user.templates.all
    generate_component_arrays
    if @workout.component_sets.count == 0
      @workout.component_sets.new(order: -1)
    end
    if @workout.component_times.count == 0
      @workout.component_times.new(order: -1)
    end
  end

  def update
    @workout = current_user.workouts.find(params[:id])
    if @workout.update(workout_params)
      redirect_to @workout
    else
      render 'edit'
    end
  end

  def show
    @this_workout = current_user.workouts.find(params[:id])
    @templates = current_user.templates.all
  end

  def destroy
    @workout = current_user.workouts.find(params[:id])
  	@workout.destroy
    respond_to do |format|
      format.js { render :layout => false }
      format.html {redirect_to root_path}
    end
  end

  def schedule_workouts
    @templates = current_user.templates.all
    @workouts = current_user.workouts.all
  end

  def save_schedule
    unless params[:scheduled].nil?
      new_workouts_array = params[:scheduled]
      new_workouts_array.each do |workout|
        date = workout[1][:start]
        @workout = Workout.new(workout_date: date,
                               completed: false,
                               user_id: current_user.id)
        load_template(current_user.templates.find(workout[1][:template_id].to_i), false)
        @workout.save
      end
    end

    response = {response: 'success'}

    respond_to do |format|
      format.json {render json: response.to_json}
    end
  end

  private

  def workout_params
    params.require(:workout).permit(:name, :workout_date, :workout_time, :completed, :notes, 
      component_sets_attributes: [:id, :kg, :reps, :num_of_sets, :workout_component_id, :rest, :_destroy], 
      component_times_attributes: [:id, :meters, :seconds, :workout_component_id, :rest, :_destroy]).merge(user_id: current_user.id)
  end


  def generate_component_arrays
    #initialize arrays to help form the exercise select boxes
    @time_component_array = Array.new
    time_components = WorkoutComponent.where(component_type: "Time").where(equipment: 'Machine')
    @time_component_array.push(['**Cardio Equipment**',''])
    time_components.each do |time_component|
      @time_component_array.push([time_component.name, time_component.id])
    end
    time_components = WorkoutComponent.where(component_type: "Time").where(equipment: 'Road/Track')
    @time_component_array.push(['',''])
    @time_component_array.push(['**Road/Track**',''])
    time_components.each do |time_component|
      @time_component_array.push([time_component.name, time_component.id])
    end
    @set_component_array = Array.new
    set_components = WorkoutComponent.where(component_type: "Reps").where(equipment: 'Machine')
    @set_component_array.push(['**Gym Machines**',''])
    set_components.each do |set_component|
      @set_component_array.push([set_component.name, set_component.id])
    end
        set_components = WorkoutComponent.where(component_type: "Reps").where(equipment: 'Free Weights')
    @set_component_array.push(['',''])
    @set_component_array.push(['**Free Weights**',''])
    set_components.each do |set_component|
      @set_component_array.push([set_component.name, set_component.id])
    end
        set_components = WorkoutComponent.where(component_type: "Reps").where(equipment: 'Body Weight Only')
    @set_component_array.push(['',''])
    @set_component_array.push(['**Body Weight Only**',''])
    set_components.each do |set_component|
      @set_component_array.push([set_component.name, set_component.id])
    end
  end

  def set_template_to_default
    #add some common workouts to get user started when opening blank 
    running = WorkoutComponent.where(name: 'Treadmill').first
    crunches = WorkoutComponent.where(name: 'Crunches').first
    pressups = WorkoutComponent.where(name: 'Press-ups').first
    @workout.component_times.new(workout_component_id: running.id)
    @workout.component_sets.new(workout_component_id: crunches.id)
    @workout.component_sets.new(workout_component_id: pressups.id)
  end

  def load_template(template, add_hidden_fields_to_copy)
    @workout.name = template.name
    @workout.notes = template.notes
    template.component_times.each do |exercise|
      @workout.component_times.new(exercise.attributes.except('id','created_at','updated_at','template_id'))
    end
    template.component_sets.each do |exercise|
      @workout.component_sets.new(exercise.attributes.except('id','created_at','updated_at','template_id'))
    end
    if add_hidden_fields_to_copy
      if template.component_sets.count == 0
        @workout.component_sets.new(order: -1)
      end
      if template.component_times.count == 0
        @workout.component_times.new(order: -1)
      end
    end
  end
end
