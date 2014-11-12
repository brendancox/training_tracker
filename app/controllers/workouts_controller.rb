class WorkoutsController < ApplicationController

  def index
    @workouts = Workout.all
  end

  def new
    @templates = Template.all
  	generate_component_arrays 
    @workout = Workout.new(params[:workout])
    if params[:template]
      load_template(Template.find(params[:template]))
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
    @workout = Workout.find(params[:id])
    @templates = Template.all
    generate_component_arrays
    if @workout.component_sets.count == 0
      @workout.component_sets.new(order: -1)
    end
    if @workout.component_times.count == 0
      @workout.component_times.new(order: -1)
    end
  end

  def update
    @workout = Workout.find(params[:id])
    if @workout.update(workout_params)
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
    @workouts = Workout.all
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
      new_workouts_array.each do |workout|
        date = workout[1][:start]
        @workout = Workout.new(workout_date: date,
                               completed: false)
        load_template(Template.find(workout[1][:template_id].to_i))
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
      component_times_attributes: [:id, :meters, :seconds, :workout_component_id, :rest, :_destroy])
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
    @time_component_array.each do |time_component|
      @workout.component_times.new(workout_component_id: time_component[1])
    end
    @set_component_array.each do |set_component|
      @workout.component_sets.new(workout_component_id: set_component[1])
    end
  end

  def load_template(template)
    @workout.name = template.name
    @workout.notes = template.notes
    template.component_times.each do |exercise|
      @workout.component_times.new(exercise.attributes.except('id','created_at','updated_at','template_id'))
    end
    template.component_sets.each do |exercise|
      @workout.component_sets.new(exercise.attributes.except('id','created_at','updated_at','template_id'))
    end
  end
end
