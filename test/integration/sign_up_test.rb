require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
	test "sign up to site" do
		visit root_path
		click_on "Sign Up"
		fill_in "user_email", with: "abc@def.com"
		fill_in "user_password", with: "password"
		fill_in "user_password_confirmation", with: "password"
		click_button "Sign up"
		assert_equal root_path, current_path
	end
end