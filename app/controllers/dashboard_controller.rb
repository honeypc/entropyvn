# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: {
      user: current_user.as_json(except: [:encrypted_password, :reset_password_token, :reset_password_sent_at, :api_token]),
      stats: {
        projects: 0,
        tasks: 0,
        completed: 0
      },
      recent_projects: [],
      recent_tasks: []
    }
  end
end
