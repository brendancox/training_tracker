class TemplatesController < WorkoutsController

  def index
    @templates = Template.all
  end


  def new
    @workout = Template.new(params[:template])
    super
  end

  def create
    this_workout = Template.create()
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
      format.html {redirect_to templates_url}
    end
  end
end
