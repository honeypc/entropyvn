# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: {
      user: user_json(current_user),
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
