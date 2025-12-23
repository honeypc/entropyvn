require "test_helper"

class AdminRolesControllerTest < ActionDispatch::IntegrationTest
  test "admin can add and remove permission on role" do
    admin_role = create_role(admin: true)
    admin = create_user(role: admin_role)
    sign_in admin

    role = create_role
    permission = create_permission

    post add_permission_admin_role_path(role), params: { permission_id: permission.id }
    assert_response :redirect
    assert_includes role.reload.permissions, permission

    delete remove_permission_admin_role_path(role), params: { permission_id: permission.id }
    assert_response :redirect
    assert_not_includes role.reload.permissions, permission
  end
end
