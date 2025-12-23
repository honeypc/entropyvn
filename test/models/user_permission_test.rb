require "test_helper"

class UserPermissionTest < ActiveSupport::TestCase
  test "requires granted to be true or false" do
    user = create_user
    permission = create_permission
    user_permission = UserPermission.new(user: user, permission: permission, granted: nil)

    assert_not user_permission.valid?
    assert_includes user_permission.errors[:granted], "is not included in the list"
  end

  test "enforces unique user and permission pairing" do
    user = create_user
    permission = create_permission
    UserPermission.create!(user: user, permission: permission, granted: true)

    duplicate = UserPermission.new(user: user, permission: permission, granted: true)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end

  test "scopes return granted and denied records" do
    user = create_user
    permission = create_permission
    granted = UserPermission.create!(user: user, permission: permission, granted: true)
    denied = UserPermission.create!(user: user, permission: create_permission, granted: false)

    assert_includes UserPermission.granted, granted
    assert_includes UserPermission.denied, denied
  end
end
