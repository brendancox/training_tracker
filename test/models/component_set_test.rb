require 'test_helper'

class ComponentSetTest < ActiveSupport::TestCase
  
  def setup
  	generate_blank_workout_with_user
  end
	
  test "cant add blank component set" do
  	@new_workout.component_sets.new
  	@new_workout.save
  	assert !ComponentSet.first, "ComponentSet added without any data"
  end

  test "require workout_component_id for ComponentSet" do
  	@new_workout.component_sets.new(reps: 10) #save other data
  	@new_workout.save
  	assert !ComponentSet.first, "ComponentSet added without any workout_component_id"
  end

  test "require workout_id for ComponentSet" do
  	new_set = @new_workout.component_sets.new(workout_component_id: 1, reps: 10) #save other data
  	new_set.workout_id = nil
  	@new_workout.save
  	assert !ComponentSet.first, "ComponentSet added without any workout_id"
  end  
end
