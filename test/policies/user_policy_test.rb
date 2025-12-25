require "test_helper"

class UserPolicyTest < ActiveSupport::TestCase
  test "admin can manage users" do
    admin_role = create_role(admin: true)
    admin = create_user(role: admin_role)
    user = create_user

    policy = UserPolicy.new(admin, user)
    assert policy.index?
    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
    assert policy.manage_roles?
    assert policy.manage_permissions?
  end

  test "user can view and update self" do
    user = create_user
    policy = UserPolicy.new(user, user)

    assert policy.show?
    assert policy.update?
    assert_not policy.destroy?
  end
end
