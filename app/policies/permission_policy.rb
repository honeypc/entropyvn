# frozen_string_literal: true

class PermissionPolicy < ApplicationPolicy
  # Only admins can view and manage permissions
  def index?
    user&.admin?
  end

  def show?
    user&.admin?
  end

  def create?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all if user&.admin?
    end
  end
end
