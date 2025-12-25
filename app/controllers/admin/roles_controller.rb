# frozen_string_literal: true

class Admin::RolesController < Admin::AdministrateBaseController
  before_action :set_role, only: %i[add_permission remove_permission]

  # POST /admin/roles/:id/add_permission
  def add_permission
    @permission = Permission.find(params[:permission_id])
    @role.permissions << @permission unless @role.permissions.include?(@permission)

    redirect_to admin_role_path(@role), notice: "Permission added to role successfully."
  end

  # DELETE /admin/roles/:id/remove_permission
  def remove_permission
    @permission = Permission.find(params[:permission_id])
    @role.permissions.delete(@permission)

    redirect_to admin_role_path(@role), notice: "Permission removed from role successfully."
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end
end
