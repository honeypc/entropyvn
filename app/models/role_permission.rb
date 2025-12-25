# frozen_string_literal: true

class RolePermission < ApplicationRecord
  # Validations
  validates :role_id, uniqueness: { scope: :permission_id }

  # Associations
  belongs_to :role
  belongs_to :permission
end
