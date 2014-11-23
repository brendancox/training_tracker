require 'test_helper'

class ComponentTimeTest < ActiveSupport::TestCase

  def setup
  	generate_blank_workout_with_user
  end

  test "cant add blank component time" do
  	@new_workout.component_times.new
  	@new_workout.save
  	assert !ComponentTime.first, "ComponentTime added without any data"
  end

  test "require workout_component_id for ComponentTime" do
  	@new_workout.component_times.new(meters: 100) #save other data
  	@new_workout.save
  	assert !ComponentTime.first, "ComponentTime added without any workout_component_id"
  end

  test "require workout_id for ComponentTime" do
  	new_time = @new_workout.component_times.new(workout_component_id: 1, meters: 100) #save other data
  	new_time.workout_id = nil
  	@new_workout.save
  	assert !ComponentTime.first, "ComponentTime added without any workout_id"
  end 
end
