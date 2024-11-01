# frozen_string_literal: true

unauthenticated do
  root 'catalog#index'
  get "/catalog/category_filter", to: "catalog#category_filter", as: :category_filter
  get '/about_us', to: 'about#index', as: :about_us
end

authenticated :user, -> { _1.operational_user? } do
  get '/', to: redirect('/operational_portal')
  get '/about_us', to: redirect('/operational_portal')
end

authenticated :user, -> { _1.customer_user? } do
  get '/', to: redirect('/customer_portal/catalog')
  get '/about_us', to: redirect('/customer_portal/catalog')
end

resources :products, only: :show
resources :parts, only: :show
