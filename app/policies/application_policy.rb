# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Index action - list all records
  def index?
    user_has_permission?('index')
  end

  # Show action - view single record
  def show?
    user_has_permission?('show') || is_owner?
  end

  # Create action - new record
  def create?
    user_has_permission?('create')
  end

  # Update action - edit existing record
  def update?
    user_has_permission?('update') || is_owner?
  end

  # Destroy action - delete record
  def destroy?
    user_has_permission?('destroy') || is_owner?
  end

  # Scope class for indexing records
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user&.admin?
        scope.all
      elsif scope.respond_to?(:where)
        # If the model has a user_id field, restrict to user's own records
        if scope.column_names.include?('user_id')
          scope.where(user: user)
        else
          scope.all
        end
      else
        scope.all
      end
    end
  end

  private

  # Check if user has permission for the resource and action
  def user_has_permission?(action)
    return false unless user
    return true if user.admin?

    user.has_permission?(model_name, action)
  end

  # Check if current user owns the record
  def is_owner?
    return false unless user
    record.respond_to?(:user_id) && record.user_id == user.id
  end

  # Get the model name from the record class
  def model_name
    record.class.name.downcase
  end
end
