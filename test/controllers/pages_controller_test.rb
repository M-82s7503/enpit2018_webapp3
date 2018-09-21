require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get inputurl" do
    get pages_inputurl_url
    assert_response :success
  end

end
