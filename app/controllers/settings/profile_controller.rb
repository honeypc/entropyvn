# frozen_string_literal: true

class Settings::ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # GET /settings/profile
  def show
    render json: { user: user_json }
  end

  # PUT/PATCH /settings/profile
  def update
    if @user.update(user_params)
      render json: { user: user_json }
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

  def user_json
    @user.as_json(
      except: [:encrypted_password, :reset_password_token, :reset_password_sent_at],
      methods: [:avatar_url]
    )
  end
end
