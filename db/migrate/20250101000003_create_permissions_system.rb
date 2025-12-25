# frozen_string_literal: true

class CreatePermissionsSystem < ActiveRecord::Migration[7.2]
  def change
    # Roles table
    create_table :roles do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.boolean :admin, default: false
      t.timestamps
    end

    # Permissions table
    create_table :permissions do |t|
      t.string :resource, null: false
      t.string :action, null: false
      t.string :condition, null: false, default: 'all'
      t.string :description
      t.timestamps
    end

    add_index :permissions, %i[resource action condition],
              unique: true,
              name: 'index_permissions_on_resource_action_condition'

    # Role permissions join table
    create_table :role_permissions do |t|
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
      t.timestamps
    end

    add_index :role_permissions, %i[role_id permission_id], unique: true

    # User roles join table
    create_table :user_roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.timestamps
    end

    add_index :user_roles, %i[user_id role_id], unique: true

    # User permissions (overrides)
    create_table :user_permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
      t.boolean :granted, default: true
      t.timestamps
    end

    add_index :user_permissions, %i[user_id permission_id], unique: true

    # Add role reference to users
    add_reference :users, :role, foreign_key: true, index: true
  end
end
