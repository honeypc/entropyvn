Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Devise routes for authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  # Authenticated routes
  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end

  # Public root
  root 'home#index'

  # Settings routes (for React components)
  namespace :settings do
    resource :profile, only: [:show, :update]
    resource :account, only: [:show, :update]
    resource :api_tokens, only: [:show, :create, :destroy]
  end

  # API endpoints
  namespace :api do
    namespace :v1 do
      resources :dashboard, only: [:index]
    end
  end
end
