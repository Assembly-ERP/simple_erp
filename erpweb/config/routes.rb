# config/routes.rb
Rails.application.routes.draw do
  get 'carts/show'
  get 'invitations/new'
  get 'invitations/create'
  get 'dashboard/index'

  # API namespace setup
  namespace :api do
    namespace :v1 do
      resources :products
      resources :parts
      resources :orders
      resources :customers
      resources :support_tickets
      resources :webhooks
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_for :operational_users, controllers: {
    registrations: 'operational_users/registrations'
  }

  devise_for :customer_users, controllers: {
    registrations: 'customer_users/registrations'
  }

  authenticated :user, ->(u) { u&.operational_user? } do
    get '/operational_portal', to: 'operational_portal/dashboard#index', as: :operational_root
  end

  authenticated :user, ->(u) { u&.customer_user? } do
    get '/customer', to: 'customer_portal/dashboard#index', as: :customer_root
  end

  unauthenticated do
    root 'home#index'
  end

  # Define routes for JWT login and logout
  post 'login', to: 'users/sessions#create'
  delete 'logout', to: 'users/sessions#destroy'

  # Operational portal namespace
  namespace :operational_portal do
    #   root to: 'operational_portal/dashboard#index'
    resources :dashboard, only: [:index]
    get 'catalog', to: 'catalog#index'
    resources :catalog, only: [:index]
    resources :products do
      collection do
        get 'search_parts'
      end
    end
    resources :parts do
      member do
        delete :delete_file
        post :upload_file
      end
    end
    resources :orders do
      collection do
        get 'preview'
        get 'fetch_parts'
        get 'fetch_products'
        get 'search_items'
      end
    end
    resources :support_tickets do
      member do
        post 'add_message', to: 'support_tickets#add_message'
        get 'preview_message_file/:message_id', to: 'support_tickets#preview_message_file', as: 'preview_message_file'
      end
      collection do
        get 'customer_users'
      end
    end
    resources :settings, only: %i[index edit update]
    resources :users
    resources :customers do
      collection do
        get 'search', to: 'customers#search', as: :search_customers
      end
      member do
        get 'details', to: 'customers#details', as: :details
      end
    end
    resources :invitations, only: %i[new create]
    resource :profile, only: %i[show edit update]
    resource :cart, only: [:show] do
      post 'add_item', on: :collection
    end
  end

  # Customer portal namespace
  namespace :customer_portal do
    root to: 'customer_portal/dashboard#index'
    resources :orders
    resources :support_tickets do
      member do
        post 'add_message', to: 'support_tickets#add_message'
      end
    end
    resource :profile, only: %i[show edit update]
    resource :cart, only: [:show] do
      post 'add_item', on: :collection
    end
  end

  # Resources accessible to all users
  resources :products, only: %i[index show]
  resources :parts, only: %i[index show]

  # Search route
  get 'search', to: 'search#index'

  # Health check route for application monitoring
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Catch-all route to handle undefined routes
  # match '*path', to: 'application#routing_error', via: :all
end
