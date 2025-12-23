# frozen_string_literal: true

class Role < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :description, length: { maximum: 255 }

  # Associations
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  # Scopes
  scope :admin, -> { where(admin: true) }
  scope :non_admin, -> { where(admin: false) }
end
