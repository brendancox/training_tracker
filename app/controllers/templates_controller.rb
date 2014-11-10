class TemplatesController < WorkoutsController

  def index
    @workouts = Template.all
  end


  def new
    super
    @workout = Template.new(params[:template])
  end

  def create
    this_workout = Template.create(name: params[:template][:name], 
                                   notes: params[:template][:notes])
    save_component_times(this_workout, params[:template][:times])
    save_component_sets(this_workout, params[:template][:sets])

    redirect_to template_url(this_workout)
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
end
