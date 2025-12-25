# frozen_string_literal: true

class Settings::ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # GET /settings/profile
  def show
    render json: { user: user_json(@user, include_api_token: true) }
  end

  # PUT/PATCH /settings/profile
  def update
    if @user.update(user_params)
      render json: { user: user_json(@user, include_api_token: true) }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end

end
