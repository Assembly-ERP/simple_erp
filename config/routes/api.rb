# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    resources :auth, only: [] do
      collection do
        get :me
        put :refresh_token
        post :sign_in
      end
    end
    resources :users
    # resources :parts
    # resources :products
    # resources :orders
    # resources :support_tickets
  end
end
