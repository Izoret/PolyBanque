require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get invite_to_group" do
    get users_invite_to_group_url
    assert_response :success
  end
end
