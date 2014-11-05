class RecordedWorkoutsController < WorkoutsController

  def index
    @workouts = RecordedWorkout.all
  end


  def new
    @workout = RecordedWorkout.new(params[:recorded_workout])
    super
  end

  def create
    this_workout = RecordedWorkout.create(name: params[:recorded_workout][:name],
                                          workout_date: flatten_date(params[:recorded_workout]),
                                          workout_time: params[:recorded_workout][:workout_time],
                                          notes: params[:recorded_workout][:notes])
    save_component_times(this_workout, params[:recorded_workout][:times])
    save_component_sets(this_workout, params[:recorded_workout][:sets])

    redirect_to recorded_workout_url(this_workout)
  end

  def show
    @this_workout = RecordedWorkout.find(params[:id])

  end

  def destroy
    @workout = RecordedWorkout.find(params[:id])
    super
  end

end
