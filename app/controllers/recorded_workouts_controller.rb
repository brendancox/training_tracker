class RecordedWorkoutsController < WorkoutsController

  def index
    @workouts = RecordedWorkout.all
  end


  def new
    @workout = RecordedWorkout.new(params[:recorded_workout])
    super
  end

  def create
    this_workout = RecordedWorkout.create(workout_time: flatten_date(params[:recorded_workout]))
    save_component_times(this_workout, params[:recorded_workout][:times])
    save_component_sets(this_workout, params[:recorded_workout][:sets])

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

end
