# frozen_string_literal: true

require "administrate/base_dashboard"

class PermissionDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    resource: Field::String,
    action: Field::String,
    condition: Field::String,
    description: Field::Text,
    roles: Field::HasMany,
    users: Field::HasMany.with_options(class_name: "UserPermission"),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    resource
    action
    condition
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    resource
    action
    condition
    description
    roles
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    resource
    action
    condition
    description
    roles
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(permission)
    "#{permission.resource}:#{permission.action}:#{permission.condition}"
  end
end
