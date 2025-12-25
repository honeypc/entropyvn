require "test_helper"

class RolePolicyTest < ActiveSupport::TestCase
  test "admin can manage roles" do
    admin_role = create_role(admin: true)
    admin = create_user(role: admin_role)
    role = create_role
    role.define_singleton_method(:system?) { false }

    policy = RolePolicy.new(admin, role)
    assert policy.index?
    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test "non-admin cannot manage roles" do
    user = create_user
    role = create_role
    role.define_singleton_method(:system?) { false }

    policy = RolePolicy.new(user, role)
    assert_not policy.index?
    assert_not policy.destroy?
  end
end
