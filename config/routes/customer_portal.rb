# frozen_string_literal: true

## Dashboards
# get '/customer_portal', to: 'customer_portal/dashboard#index', as: :customer_root

namespace :customer_portal do
  resources :catalog, only: %i[index] do
    collection do
      get :category_filter
    end
  end
  resources :orders do
    member do
      get :quote_or_invoice
    end
  end
  resources :parts, only: :show
  resources :products, only: :show
  resources :support_tickets do
    member do
      get :messages
      post :add_message
    end
  end
  resources :carts, path: "cart"
  resource :profile, only: %i[show edit update]
end
