# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # Users can view other users only if they have permission
  def index?
    user&.admin?
  end

  def show?
    user&.admin? || user == record
  end

  # Only admins can create new users
  def create?
    user&.admin?
  end

  # Users can update their own profile, admins can update any
  def update?
    user&.admin? || user == record
  end

  # Only admins can destroy users
  def destroy?
    user&.admin? && user != record
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

  # Additional permissions for managing roles
  def manage_roles?
    user&.admin?
  end

  # Additional permissions for managing permissions
  def manage_permissions?
    user&.admin?
  end
end
