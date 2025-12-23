require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "get root" do
    get root_path
    assert_response :success
  end
end
