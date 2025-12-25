require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated users" do
    get authenticated_root_path
    assert_response :redirect
  end

  test "returns dashboard payload for authenticated users" do
    user = create_user
    sign_in user

    get authenticated_root_path, as: :json
    assert_response :success

    payload = JSON.parse(response.body)
    assert_equal user.email, payload.dig("user", "email")
    assert payload.key?("stats")
    assert payload.key?("recent_projects")
    assert payload.key?("recent_tasks")
  end
end
