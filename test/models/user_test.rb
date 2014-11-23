require 'test_helper'

class UserTest < ActiveSupport::TestCase
	
  test "email added to test db" do 
  	user = users(:one)
  	assert user.email
  end
end
