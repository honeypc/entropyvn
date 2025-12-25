require "test_helper"

class SettingsProfileControllerTest < ActionDispatch::IntegrationTest
  test "shows profile for authenticated user" do
    user = create_user
    sign_in user

    get settings_profile_path, as: :json
    assert_response :success

    payload = JSON.parse(response.body)
    assert_equal user.email, payload.dig("user", "email")
  end

  test "updates profile with valid data" do
    user = create_user
    sign_in user

    patch settings_profile_path, params: { user: { name: "Updated Name" } }, as: :json
    assert_response :success

    assert_equal "Updated Name", user.reload.name
  end

  test "returns errors for invalid update" do
    user = create_user
    sign_in user

    patch settings_profile_path, params: { user: { name: "" } }, as: :json
    assert_response :unprocessable_entity

    payload = JSON.parse(response.body)
    assert_includes payload["errors"], "Name can't be blank"
  end
end
