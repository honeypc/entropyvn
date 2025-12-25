require "test_helper"

class SettingsApiTokensControllerTest < ActionDispatch::IntegrationTest
  test "shows masked token" do
    user = create_user(api_token: "12345678-abcdef")
    sign_in user

    get settings_api_tokens_path, as: :json
    assert_response :success

    payload = JSON.parse(response.body)
    assert_equal "12345678...", payload["api_token"]
    assert payload["has_token"]
  end

  test "creates a new api token" do
    user = create_user(api_token: nil)
    sign_in user

    post settings_api_tokens_path, as: :json
    assert_response :success

    payload = JSON.parse(response.body)
    assert payload["api_token"].present?
    assert_equal payload["api_token"], user.reload.api_token
  end

  test "destroys api token" do
    user = create_user(api_token: "token-keep")
    sign_in user

    delete settings_api_tokens_path, as: :json
    assert_response :no_content
    assert_nil user.reload.api_token
  end
end
