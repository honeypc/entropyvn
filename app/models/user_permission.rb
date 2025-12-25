# frozen_string_literal: true

class UserPermission < ApplicationRecord
  # Validations
  validates :user_id, uniqueness: { scope: :permission_id }
  validates :granted, inclusion: { in: [true, false] }

  # Associations
  belongs_to :user
  belongs_to :permission

  # Scopes
  scope :granted, -> { where(granted: true) }
  scope :denied, -> { where(granted: false) }
end
