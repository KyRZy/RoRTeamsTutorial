require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get tutorial" do
    get home_tutorial_url
    assert_response :success
  end

end
