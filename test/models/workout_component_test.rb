require 'test_helper'

class WorkoutComponentTest < ActiveSupport::TestCase

  test "seeds added to test db" do
  	load_seeds
    assert WorkoutComponent.first
  end
end
