ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def load_seeds
  	Rails.application.load_seed
  end

  def generate_blank_workout_with_user
  	@user = users(:one)
  	@new_workout = @user.workouts.new
  end

  # Add more helper methods to be used by all tests here...
end
