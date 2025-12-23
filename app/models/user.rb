class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Active Storage for avatar
  has_one_attached :avatar

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :api_token, uniqueness: { allow_nil: true }, allow_nil: true

  # Generate API token before creation
  before_validation :generate_api_token, on: :create

  # Get avatar URL for JSON responses
  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.url_for(avatar) : nil
  end

  private

  def generate_api_token
    self.api_token ||= SecureRandom.uuid + "-" + SecureRandom.hex(16)
  end
end
