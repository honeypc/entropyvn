require "test_helper"

class AdminUsersControllerTest < ActionDispatch::IntegrationTest
  test "admin can assign and remove roles" do
    admin_role = create_role(admin: true)
    admin = create_user(role: admin_role)
    sign_in admin

    role = create_role
    user = create_user

    post assign_role_admin_user_path(user), params: { role_id: role.id }
    assert_response :redirect
    assert_includes user.reload.roles, role

    delete remove_role_admin_user_path(user), params: { role_id: role.id }
    assert_response :redirect
    assert_not_includes user.reload.roles, role
  end

  test "admin can grant and revoke permissions" do
    admin_role = create_role(admin: true)
    admin = create_user(role: admin_role)
    sign_in admin

    user = create_user
    permission = create_permission

    post grant_permission_admin_user_path(user), params: { permission_id: permission.id, granted: "false" }
    assert_response :redirect
    assert_equal false, user.user_permissions.find_by(permission: permission).granted

    delete revoke_permission_admin_user_path(user), params: { permission_id: permission.id }
    assert_response :redirect
    assert_nil user.user_permissions.find_by(permission: permission)
  end
end
