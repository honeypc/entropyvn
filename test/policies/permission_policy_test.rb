require "test_helper"

class PermissionPolicyTest < ActiveSupport::TestCase
  test "admin can manage permissions" do
    admin_role = create_role(admin: true)
    admin = create_user(role: admin_role)
    permission = create_permission

    policy = PermissionPolicy.new(admin, permission)
    assert policy.index?
    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test "non-admin cannot manage permissions" do
    user = create_user
    permission = create_permission

    policy = PermissionPolicy.new(user, permission)
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
  end
end
