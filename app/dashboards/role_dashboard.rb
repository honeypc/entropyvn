# frozen_string_literal: true

require "administrate/base_dashboard"

class RoleDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    admin: Field::Boolean,
    permissions: Field::HasMany,
    users: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    description
    admin
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    description
    admin
    permissions
    users
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    description
    admin
    permissions
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(role)
    role.name
  end
end
