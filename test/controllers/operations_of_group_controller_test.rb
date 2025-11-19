require "test_helper"

class OperationsOfGroupControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get operations_of_group_index_url
    assert_response :success
  end
end
