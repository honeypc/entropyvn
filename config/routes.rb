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

  # Locale switching
  get 'locale/:locale', to: 'application#switch_locale', as: :switch_locale

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

  # Admin routes (admin only access)
  namespace :admin do
    authenticate :user, ->(u) { u&.admin? } do
      root to: "dashboard#index"

      # Administrate dashboard
      resources :users, only: [:index, :show, :edit, :update, :new, :create, :destroy]
      resources :roles, only: [:index, :show, :edit, :update, :new, :create, :destroy]
      resources :permissions, only: [:index, :show, :edit, :update, :new, :create, :destroy]

      # Custom role management routes
      resources :roles do
        member do
          post :add_permission
          delete :remove_permission
        end
      end

      # Custom user management routes
      resources :users do
        member do
          post :assign_role
          delete :remove_role
          post :grant_permission
          delete :revoke_permission
        end
      end
    end
  end
end
