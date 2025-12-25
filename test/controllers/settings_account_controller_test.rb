require "test_helper"

class SettingsAccountControllerTest < ActionDispatch::IntegrationTest
  test "shows account data for authenticated user" do
    user = create_user
    sign_in user

    get settings_account_path, as: :json
    assert_response :success

    payload = JSON.parse(response.body)
    assert_equal user.email, payload.dig("user", "email")
  end

  test "rejects password update without password" do
    user = create_user
    sign_in user

    patch settings_account_path, params: { user: { password: "" } }, as: :json
    assert_response :unprocessable_entity

    payload = JSON.parse(response.body)
    assert_includes payload["errors"], "Password can't be blank"
  end

  test "updates password with valid data" do
    user = create_user
    sign_in user

    patch settings_account_path, params: { user: { password: "newpassword", password_confirmation: "newpassword" } }, as: :json
    assert_response :success
  end
end
