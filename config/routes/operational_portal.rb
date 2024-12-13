# frozen_string_literal: true

# Dashboards
get '/operational_portal', to: 'operational_portal/dashboard#index', as: :operational_root
get '/operational_portal/manage', to: redirect('/operational_portal/users')

namespace :operational_portal do
  resources :catalog, only: :index do
    collection do
      get :category_filter
    end
  end
  resources :products do
    collection do
      get :search_part_results
    end
  end
  resources :parts
  resources :orders do
    member do
      get :make_ticket
      get :quote_or_invoice
      put :update_summary
      delete :cancel
    end
    collection do
      get :search_catalog
    end
  end
  resources :support_tickets do
    member do
      get :messages
      post :add_message
    end
  end
  resources :customer_imports, only: %i[index create]
  resources :settings, only: %i[index edit update]
  resources :order_price_schedulers, only: %i[index]
  resources :users
  resources :customers do
    member do
      get :users
    end
  end
  resources :invitations, only: %i[new create]
  resource :profile, only: %i[show edit update]
  resource :billing, only: %i[edit update]
  resource :branding, only: %i[edit update]
end
