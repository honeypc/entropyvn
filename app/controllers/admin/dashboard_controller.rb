# frozen_string_literal: true

class Admin::DashboardController < Admin::AdministrateBaseController
  layout "administrate/application"

  def index
    @stats = {
      users: User.count,
      roles: Role.count,
      permissions: Permission.count
    }
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_roles = Role.order(created_at: :desc).limit(5)
  end
end
