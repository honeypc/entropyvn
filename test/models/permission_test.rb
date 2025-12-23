require "test_helper"

class PermissionTest < ActiveSupport::TestCase
  test "requires resource action condition" do
    permission = Permission.new
    assert_not permission.valid?
    assert_includes permission.errors[:resource], "can't be blank"
    assert_includes permission.errors[:action], "can't be blank"
    assert_includes permission.errors[:condition], "can't be blank"
  end

  test "enforces unique resource action condition" do
    create_permission(resource: "project", action: "read", condition: "all")
    permission = Permission.new(resource: "project", action: "read", condition: "all")
    assert_not permission.valid?
    assert_includes permission.errors[:resource], "has already been taken"
  end

  test "full_name returns composed name" do
    permission = create_permission(resource: "project", action: "read", condition: "own")
    assert_equal "project:read:own", permission.full_name
  end

  test "find_or_create_permission returns existing or new record" do
    permission = Permission.find_or_create_permission("ticket", "manage", "all")
    assert permission.persisted?
    assert_equal permission, Permission.find_or_create_permission("ticket", "manage", "all")
  end

  test "scopes filter permissions" do
    read = create_permission(resource: "project", action: "read", condition: "all")
    update = create_permission(resource: "project", action: "update", condition: "own")

    assert_includes Permission.for_action("read"), read
    assert_includes Permission.for_resource("project"), update
    assert_includes Permission.own_scope, update
    assert_not_includes Permission.all_scope, update
  end
end
