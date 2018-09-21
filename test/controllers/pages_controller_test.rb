require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get inputurl" do
    get pages_inputurl_url
  end

  test "should get user" do
    get pages_user_url
    assert_response :success
  end

end
