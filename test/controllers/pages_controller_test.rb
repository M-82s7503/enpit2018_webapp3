require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get user" do
    get pages_user_url
    assert_response :success
  end

end
