require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "requires a name" do
    role = Role.new(description: "desc")
    assert_not role.valid?
    assert_includes role.errors[:name], "can't be blank"
  end

  test "enforces unique name" do
    create_role(name: "manager")
    role = Role.new(name: "manager")
    assert_not role.valid?
    assert_includes role.errors[:name], "has already been taken"
  end

  test "admin scope returns admin roles" do
    admin_role = create_role(admin: true)
    create_role(admin: false)

    assert_includes Role.admin, admin_role
    assert_not_includes Role.non_admin, admin_role
  end
end
