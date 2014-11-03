class ScheduledWorkoutsController < WorkoutsController

  def index
    @workouts = ScheduledWorkout.all
  end


  def new
    @workout = ScheduledWorkout.new(params[:workout])
    super
  end

  def create
    this_workout = ScheduledWorkout.create(workout_time: flatten_date(params[:scheduled_workout]))
    save_component_times(this_workout, params[:scheduled_workout][:times])
    save_component_sets(this_workout, params[:scheduled_workout][:sets])

    redirect_to scheduled_workout_url(this_workout)
  end

  def show
    @this_workout = ScheduledWorkout.find(params[:id])

  end

  def destroy
    @workout = ScheduledWorkout.find(params[:id])
    super
  end

end