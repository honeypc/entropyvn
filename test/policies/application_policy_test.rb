require "test_helper"

class ApplicationPolicyTest < ActiveSupport::TestCase
  test "uses permissions for action checks" do
    user = create_user
    role = create_role
    permission = create_permission(resource: "role", action: "update", condition: "all")
    role.permissions << permission
    user.roles << role

    policy = ApplicationPolicy.new(user, Role.new)
    assert policy.update?
  end

  test "allows owners to show and update" do
    user = create_user
    permission = create_permission
    record = UserPermission.new(user: user, permission: permission)
    policy = ApplicationPolicy.new(user, record)

    assert policy.show?
    assert policy.update?
  end

  test "scope returns all for admins and own records for non-admins" do
    admin_role = create_role(admin: true)
    admin = create_user(role: admin_role)
    user = create_user

    user_permission = UserPermission.create!(user: user, permission: create_permission, granted: true)
    admin_permission = UserPermission.create!(user: admin, permission: create_permission, granted: true)

    admin_scope = ApplicationPolicy::Scope.new(admin, UserPermission).resolve
    assert_includes admin_scope, user_permission
    assert_includes admin_scope, admin_permission

    user_scope = ApplicationPolicy::Scope.new(user, UserPermission).resolve
    assert_includes user_scope, user_permission
    assert_not_includes user_scope, admin_permission
  end
end
