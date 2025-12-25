# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  # Only admins can manage roles
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
    user&.admin? && !record.system?
  end

  class Scope < Scope
    def resolve
      scope.all if user&.admin?
    end
  end
end
