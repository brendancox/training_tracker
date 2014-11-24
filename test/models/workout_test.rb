require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  test "should not save workout with no user id" do
  	generate_blank_workout_with_user
  	@new_workout.user = nil
  	@new_workout.save
  	assert !Workout.first, "Saved workout without user_id"
  end

  test "does save workout when necessary parameters present" do
  	generate_blank_workout_with_user
  	@new_workout.save
  	assert Workout.first, "Did not save workout"
  end
end
