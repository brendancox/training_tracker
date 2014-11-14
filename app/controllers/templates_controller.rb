class TemplatesController < WorkoutsController

  before_action :authenticate_user!

  def index
    @workouts = current_user.templates.all
    @templates = current_user.templates.all
  end


  def new
    super
    @workout = Template.new(params[:template])
    if params[:template]
      load_template(current_user.templates.find(params[:template]), true)
    else
      set_template_to_default
    end
  end

  def create
    this_workout = Template.create(template_params)
    redirect_to template_url(this_workout)
  end

  def edit
    @workout = current_user.templates.find(params[:id])
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
    @workout = current_user.templates.find(params[:id])
    if @workout.update(template_params)
      redirect_to @workout
    else
      render 'edit'
    end
  end

  def show
    @this_workout = current_user.templates.find(params[:id])
    @templates = current_user.templates.all
  end

  def destroy
    @workout = current_user.templates.find(params[:id])
    @workout.destroy

    respond_to do |format|
      format.js { render :layout => false }
      format.html {redirect_to root_path}
    end
    
  end

  private

  def template_params
    params.require(:template).permit(:name, :notes, 
      component_sets_attributes: [:id, :kg, :reps, :num_of_sets, :workout_component_id, :rest, :_destroy], 
      component_times_attributes: [:id, :meters, :seconds, :workout_component_id, :rest, :_destroy]).merge(user_id: current_user.id)
  end

end