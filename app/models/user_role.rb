# frozen_string_literal: true

class UserRole < ApplicationRecord
  # Validations
  validates :user_id, uniqueness: { scope: :role_id }

  # Associations
  belongs_to :user
  belongs_to :role
end
