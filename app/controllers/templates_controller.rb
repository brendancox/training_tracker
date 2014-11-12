class TemplatesController < WorkoutsController

  def index
    @workouts = Template.all
  end


  def new
    super
    @workout = Template.new(params[:template])
    if params[:template]
      load_template(Template.find(params[:template]))
    else
      set_template_to_default
    end
  end

  def create
    this_workout = Template.create(template_params)
    redirect_to template_url(this_workout)
  end

  def edit
    @workout = Template.find(params[:id])
    @templates = Template.all
    generate_component_arrays
  end

  def update
    @workout = Template.find(params[:id])
    if @workout.update(template_params)
      redirect_to @workout
    else
      render 'edit'
    end
  end

  def show
    @this_workout = Template.find(params[:id])
  end

  def destroy
    @workout = Template.find(params[:id])
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
      component_times_attributes: [:id, :meters, :seconds, :workout_component_id, :rest, :_destroy])
  end

end