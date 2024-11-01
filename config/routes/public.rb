# frozen_string_literal: true

unauthenticated do
  root 'catalog#index'
  get "/catalog/category_filter", to: "catalog#category_filter", as: :category_filter
  get '/about_us', to: 'about#index', as: :about_us
end

resources :products, only: :show
resources :parts, only: :show
