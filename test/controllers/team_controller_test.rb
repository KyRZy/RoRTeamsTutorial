require 'test_helper'

class TeamControllerTest < ActionDispatch::IntegrationTest
  test "should get name:string" do
    get team_name:string_url
    assert_response :success
  end

  test "should get encrypted_password:string" do
    get team_encrypted_password:string_url
    assert_response :success
  end

  test "should get salt:string" do
    get team_salt:string_url
    assert_response :success
  end

  test "should get leader_id:integer" do
    get team_leader_id:integer_url
    assert_response :success
  end

end
