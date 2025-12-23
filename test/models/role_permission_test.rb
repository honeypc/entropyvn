require "test_helper"

class RolePermissionTest < ActiveSupport::TestCase
  test "enforces unique role and permission pairing" do
    role = create_role
    permission = create_permission
    RolePermission.create!(role: role, permission: permission)

    duplicate = RolePermission.new(role: role, permission: permission)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:role_id], "has already been taken"
  end
end
