ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "securerandom"

Rails.application.routes.default_url_options[:host] = "example.test"

module TestDataHelpers
  def build_user(**attrs)
    defaults = {
      email: "user-#{SecureRandom.hex(4)}@example.test",
      password: "password",
      password_confirmation: "password",
      name: "Test User"
    }
    User.new(defaults.merge(attrs))
  end

  def create_user(**attrs)
    build_user(**attrs).tap(&:save!)
  end

  def create_role(**attrs)
    defaults = {
      name: "role-#{SecureRandom.hex(4)}",
      description: "Test role"
    }
    Role.create!(defaults.merge(attrs))
  end

  def create_permission(**attrs)
    defaults = {
      resource: "resource-#{SecureRandom.hex(3)}",
      action: "action-#{SecureRandom.hex(3)}",
      condition: "all",
      description: "Test permission"
    }
    Permission.create!(defaults.merge(attrs))
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include TestDataHelpers
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
