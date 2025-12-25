require "test_helper"

class UserRoleTest < ActiveSupport::TestCase
  test "enforces unique user and role pairing" do
    user = create_user
    role = create_role
    UserRole.create!(user: user, role: role)

    duplicate = UserRole.new(user: user, role: role)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end
end
