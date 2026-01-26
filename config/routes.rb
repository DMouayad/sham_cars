Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files (Rails 8)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # ===================
  # Authentication (from authentication-zero)
  # ===================
  resource :session, only: %i[new create destroy]
  resources :passwords, param: :token, only: %i[new create edit update]

  # Friendly aliases
  get "sign_in", to: "sessions#new", as: :sign_in
  get "sign_up", to: "registrations#new", as: :sign_up if defined?(RegistrationsController)
  get "password_reset" , to: "passwords#new" , as: :password_reset

  # ===================
  # Public Routes
  # ===================
  root "pages#home"

  get "about", to: "pages#about"

  resources :vehicles, only: %i[index show], param: :slug
  resources :brands, only: %i[index show], param: :slug

  # Comparison (session-based)
  resource :comparison, only: [:show] do
    post "add/:slug", action: :add, as: :add
    delete "remove/:slug", action: :remove, as: :remove
    delete "clear", action: :clear, as: :clear
  end

  # ===================
  # API v1 (for Flutter)
  # ===================
  namespace :api do
    namespace :v1 do
      resources :vehicles, only: %i[index show], param: :slug
      resources :brands, only: %i[index show], param: :slug
      resources :body_types, only: [:index]

      post "compare", to: "comparisons#compare"
    end
  end

  # ===================
  # Admin Panel
  # ===================
  namespace :admin do
    root "dashboard#index"

    resources :vehicles do
      member do
        patch :publish
        patch :unpublish
        patch :toggle_featured
      end
    end

    resources :brands
    resources :body_types
    resources :users, only: %i[index edit update destroy]
  end
end
