# frozen_string_literal: true

class Permission < ApplicationRecord
  # Validations
  validates :resource, presence: true, length: { maximum: 50 }
  validates :action, presence: true, length: { maximum: 50 }
  validates :condition, presence: true, length: { maximum: 50 }, inclusion: { in: %w[all own custom] }
  validates :description, length: { maximum: 255 }
  validates :resource, uniqueness: { scope: %i[action condition] }

  # Associations
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions
  has_many :user_permissions, dependent: :destroy
  has_many :users, through: :user_permissions

  # Scopes
  scope :for_resource, ->(resource) { where(resource: resource) }
  scope :for_action, ->(action) { where(action: action) }
  scope :all_scope, -> { where(condition: 'all') }
  scope :own_scope, -> { where(condition: 'own') }
  scope :custom_scope, -> { where(condition: 'custom') }

  # Class method to find or create a permission
  def self.find_or_create_permission(resource, action, condition = 'all')
    find_or_create_by(resource: resource, action: action, condition: condition)
  end

  # Full permission name for display
  def full_name
    "#{resource}:#{action}:#{condition}"
  end
end
