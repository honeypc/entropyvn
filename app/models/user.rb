class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Active Storage for avatar
  has_one_attached :avatar

  # Role and Permission associations
  belongs_to :role, optional: true
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :user_permissions, dependent: :destroy
  has_many :permissions, through: :user_permissions

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :api_token, uniqueness: { allow_nil: true }, allow_nil: true

  # Generate API token before creation
  before_validation :generate_api_token, on: :create

  # Get avatar URL for JSON responses
  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.url_for(avatar) : nil
  end

  # Check if user has a specific role
  def has_role?(role_name)
    roles.exists?(name: role_name.to_s)
  end

  # Check if user has admin role
  def admin?
    has_role?(:admin) || role&.admin?
  end

  # Check if user has permission for resource/action
  def has_permission?(resource, action, condition = 'all')
    return true if admin?

    # Check role permissions
    roles.joins(:permissions).where(
      permissions: { resource: resource.to_s, action: action.to_s, condition: condition }
    ).exists?
  end

  # Check if user can manage a specific record (all scope)
  def can_manage?(record)
    has_permission?(record.class.name.downcase, 'manage', 'all')
  end

  # Check if user can update own record
  def can_update_own?(record)
    return false unless record.respond_to?(:user_id)
    record.user_id == id && has_permission?(record.class.name.downcase, 'update', 'own')
  end

  # Check if user owns a record
  def is_owner?(record)
    record.respond_to?(:user_id) && record.user_id == id
  end

  # Check user permission override (granted/denied)
  def permission_override_for(permission)
    user_permissions.find_by(permission: permission)&.granted
  end

  private

  def generate_api_token
    self.api_token ||= SecureRandom.uuid + "-" + SecureRandom.hex(16)
  end
end
