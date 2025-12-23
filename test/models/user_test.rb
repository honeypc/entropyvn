require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with required attributes" do
    user = build_user
    assert user.valid?
  end

  test "requires a name" do
    user = build_user(name: nil)
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "enforces api_token uniqueness when present" do
    token = "token-123"
    create_user(api_token: token)
    user = build_user(api_token: token)
    assert_not user.valid?
    assert_includes user.errors[:api_token], "has already been taken"
  end

  test "generates api_token on create" do
    user = create_user(api_token: nil)
    assert user.api_token.present?
  end

  test "has_role? checks assigned roles" do
    user = create_user
    role = create_role(name: "editor")
    user.roles << role

    assert user.has_role?(:editor)
    assert_not user.has_role?(:admin)
  end

  test "admin? is true for admin roles" do
    admin_role = create_role(name: "admin", admin: true)
    user = create_user(role: admin_role)

    assert user.admin?
  end

  test "has_permission? checks role permissions" do
    user = create_user
    role = create_role
    permission = create_permission(resource: "project", action: "manage", condition: "all")
    role.permissions << permission
    user.roles << role

    assert user.has_permission?("project", "manage", "all")
    assert_not user.has_permission?("project", "delete", "all")
  end

  test "can_manage? checks manage permission against record" do
    user = create_user
    role = create_role
    permission = create_permission(resource: "role", action: "manage", condition: "all")
    role.permissions << permission
    user.roles << role

    assert user.can_manage?(Role.new)
  end

  test "can_update_own? requires ownership and permission" do
    user = create_user
    role = create_role
    permission = create_permission(resource: "userpermission", action: "update", condition: "own")
    role.permissions << permission
    user.roles << role

    record = UserPermission.new(user: user, permission: permission)
    assert user.can_update_own?(record)

    other_user = create_user
    record.user = other_user
    assert_not user.can_update_own?(record)
  end

  test "is_owner? checks record ownership" do
    user = create_user
    permission = create_permission
    record = UserPermission.new(user: user, permission: permission)

    assert user.is_owner?(record)
  end

  test "permission_override_for returns granted flag when present" do
    user = create_user
    permission = create_permission
    UserPermission.create!(user: user, permission: permission, granted: false)

    assert_equal false, user.permission_override_for(permission)
  end

  test "avatar_url returns nil when no avatar attached" do
    user = create_user
    assert_nil user.avatar_url
  end
end
