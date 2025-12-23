# frozen_string_literal: true

require "administrate/base_dashboard"

class Admin::UsersController < Admin::AdministrateBaseController
  before_action :set_user, only: %i[assign_role remove_role grant_permission revoke_permission]

  # POST /admin/users/:id/assign_role
  def assign_role
    @role = Role.find(params[:role_id])
    @user.roles << @role unless @user.roles.include?(@role)

    redirect_to admin_user_path(@user), notice: "Role assigned successfully."
  end

  # DELETE /admin/users/:id/remove_role
  def remove_role
    @role = Role.find(params[:role_id])
    @user.roles.delete(@role)

    redirect_to admin_user_path(@user), notice: "Role removed successfully."
  end

  # POST /admin/users/:id/grant_permission
  def grant_permission
    @permission = Permission.find(params[:permission_id])
    granted = params[:granted] != 'false'

    UserPermission.find_or_create_by!(user: @user, permission: @permission) do |up|
      up.granted = granted
    end

    redirect_to admin_user_path(@user), notice: "Permission granted successfully."
  end

  # DELETE /admin/users/:id/revoke_permission
  def revoke_permission
    @permission = Permission.find(params[:permission_id])
    @user.user_permissions.where(permission: @permission).destroy_all

    redirect_to admin_user_path(@user), notice: "Permission revoked successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
