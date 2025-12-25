# frozen_string_literal: true

class Settings::ApiTokensController < ApplicationController
  before_action :authenticate_user!

  # GET /settings/api_tokens
  def show
    # Only show first 8 characters of token for security
    masked_token = current_user.api_token ? "#{current_user.api_token[0..7]}..." : nil
    render json: {
      api_token: masked_token,
      has_token: current_user.api_token.present?
    }
  end

  # POST /settings/api_tokens
  def create
    new_token = SecureRandom.uuid + "-" + SecureRandom.hex(16)
    current_user.update(api_token: new_token)
    render json: {
      api_token: new_token,
      message: "New API token generated. Save it now, you won't be able to see it again!"
    }
  end

  # DELETE /settings/api_tokens
  def destroy
    current_user.update(api_token: nil)
    head :no_content
  end
end
