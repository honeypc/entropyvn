# frozen_string_literal: true

class Settings::AccountController < ApplicationController
  before_action :authenticate_user!

  # GET /settings/account
  def show
    render json: { user: user_json(current_user) }
  end

  # PUT/PATCH /settings/account
  def update
    if update_user
      render json: { user: user_json(current_user), message: "Password updated successfully" }
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def update_user
    # Only allow password updates through this controller
    if params[:user][:password].present?
      current_user.update(user_params)
    else
      current_user.errors.add(:password, "can't be blank")
      false
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
