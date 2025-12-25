# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating roles and permissions..."

# Create roles
admin_role = Role.find_or_create_by!(name: 'admin') do |role|
  role.description = 'Full system access with all permissions'
  role.admin = true
end

moderator_role = Role.find_or_create_by!(name: 'moderator') do |role|
  role.description = 'Content moderator with limited management permissions'
  role.admin = false
end

user_role = Role.find_or_create_by!(name: 'user') do |role|
  role.description = 'Regular user with standard permissions'
  role.admin = false
end

guest_role = Role.find_or_create_by!(name: 'guest') do |role|
  role.description = 'Guest user with read-only permissions'
  role.admin = false
end

# Define resources for permissions
resources = %w[users roles permissions projects tasks comments]

# Define actions for permissions
actions = %w[index show create update destroy manage]

# Define conditions for permissions
conditions = %w[all own custom]

# Create all permissions
resources.each do |resource|
  actions.each do |action|
    conditions.each do |condition|
      Permission.find_or_create_by!(
        resource: resource,
        action: action,
        condition: condition
      ) do |perm|
        perm.description = "#{action.capitalize} #{resource} (#{condition})"
      end
    end
  end
end

puts "Permissions created!"

# Assign all permissions to admin role
Permission.all.each do |permission|
  RolePermission.find_or_create_by!(role: admin_role, permission: permission)
end

puts "Admin permissions assigned!"

# Assign limited permissions to moderator role
# Moderators can manage content but not users/roles/permissions
moderator_permissions = []
%w[projects tasks comments].each do |resource|
  %w[index show create update].each do |action|
    moderator_permissions << Permission.find_by(resource: resource, action: action, condition: 'all')
  end
end

moderator_permissions.compact.each do |permission|
  RolePermission.find_or_create_by!(role: moderator_role, permission: permission)
end

puts "Moderator permissions assigned!"

# Assign basic permissions to user role
# Users can manage their own data
user_permissions = []
%w[projects tasks comments].each do |resource|
  %w[index show create update].each do |action|
    user_permissions << Permission.find_by(resource: resource, action: action, condition: 'own')
  end
end

user_permissions.compact.each do |permission|
  RolePermission.find_or_create_by!(role: user_role, permission: permission)
end

puts "User permissions assigned!"

# Assign read-only permissions to guest role
guest_permissions = []
%w[projects tasks comments].each do |resource|
  guest_permissions << Permission.find_by(resource: resource, action: 'index', condition: 'all')
  guest_permissions << Permission.find_by(resource: resource, action: 'show', condition: 'all')
end

guest_permissions.compact.each do |permission|
  RolePermission.find_or_create_by!(role: guest_role, permission: permission)
end

puts "Guest permissions assigned!"

# Create default admin user if none exists
if User.where(email: 'admin@example.com').none?
  admin_user = User.create!(
    email: 'admin@example.com',
    password: 'Admin123!',
    password_confirmation: 'Admin123!',
    name: 'System Administrator'
  )
  admin_user.roles << admin_role
  puts "Default admin user created: admin@example.com / Admin123!"
else
  puts "Admin user already exists"
end

puts "Seed completed successfully!"
