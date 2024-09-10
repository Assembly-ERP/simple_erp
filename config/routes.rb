Rails.application.routes.draw do
  unauthenticated :user do
    root 'home#index'
  end

  authenticated :user, -> { _1.operational_user? } do
    get '/', to: redirect('/operational_portal')
  end

  authenticated :user, -> { _1.customer_user? } do
    get '/', to: redirect('/customer')
  end

  # Auth
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Dashboards
  get '/operational_portal', to: 'operational_portal/dashboard#index', as: :operational_root
  get '/customer', to: 'customer_portal/dashboard#index', as: :customer_root

  # Operational portal namespace
  get '/operational_portal/manage', to: redirect('/operational_portal/users')

  namespace :operational_portal do
    resources :catalog, only: [:index]
    resources :products do
      collection do
        get :search_part_results
      end
    end
    resources :parts do
      member do
        delete :delete_file
        post :upload_file
      end
    end
    resources :orders do
      member do
        post :sync_price
        put :update_shipping
      end
      collection do
        get :search_results
      end
    end
    resources :support_tickets do
      member do
        post 'add_message', to: 'support_tickets#add_message'
        get 'preview_message_file/:message_id', to: 'support_tickets#preview_message_file', as: 'preview_message_file'
      end
      collection do
        get :customer_users
        get :form_user_selection
      end
    end
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

  # Health check route for application monitoring
  get 'up' => 'rails/health#show', as: :rails_health_check
end

# == Route Map
#
#                                                 Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                                   root GET    /                                                                                                 home#index
#                                                        GET    /                                                                                                 redirect(301, /operational_portal)
#                                                        GET    /                                                                                                 redirect(301, /customer)
#                                       new_user_session GET    /users/sign_in(.:format)                                                                          devise/sessions#new
#                                           user_session POST   /users/sign_in(.:format)                                                                          devise/sessions#create
#                                   destroy_user_session DELETE /users/sign_out(.:format)                                                                         devise/sessions#destroy
#                                      new_user_password GET    /users/password/new(.:format)                                                                     devise/passwords#new
#                                     edit_user_password GET    /users/password/edit(.:format)                                                                    devise/passwords#edit
#                                          user_password PATCH  /users/password(.:format)                                                                         devise/passwords#update
#                                                        PUT    /users/password(.:format)                                                                         devise/passwords#update
#                                                        POST   /users/password(.:format)                                                                         devise/passwords#create
#                               cancel_user_registration GET    /users/cancel(.:format)                                                                           users/registrations#cancel
#                                  new_user_registration GET    /users/sign_up(.:format)                                                                          users/registrations#new
#                                 edit_user_registration GET    /users/edit(.:format)                                                                             users/registrations#edit
#                                      user_registration PATCH  /users(.:format)                                                                                  users/registrations#update
#                                                        PUT    /users(.:format)                                                                                  users/registrations#update
#                                                        DELETE /users(.:format)                                                                                  users/registrations#destroy
#                                                        POST   /users(.:format)                                                                                  users/registrations#create
#                                  new_user_confirmation GET    /users/confirmation/new(.:format)                                                                 devise/confirmations#new
#                                      user_confirmation GET    /users/confirmation(.:format)                                                                     devise/confirmations#show
#                                                        POST   /users/confirmation(.:format)                                                                     devise/confirmations#create
#                                       operational_root GET    /operational_portal(.:format)                                                                     operational_portal/dashboard#index
#                                          customer_root GET    /customer(.:format)                                                                               customer_portal/dashboard#index
#                              operational_portal_manage GET    /operational_portal/manage(.:format)                                                              redirect(301, /operational_portal/users)
#                       operational_portal_catalog_index GET    /operational_portal/catalog(.:format)                                                             operational_portal/catalog#index
#        search_part_results_operational_portal_products GET    /operational_portal/products/search_part_results(.:format)                                        operational_portal/products#search_part_results
#                            operational_portal_products GET    /operational_portal/products(.:format)                                                            operational_portal/products#index
#                                                        POST   /operational_portal/products(.:format)                                                            operational_portal/products#create
#                         new_operational_portal_product GET    /operational_portal/products/new(.:format)                                                        operational_portal/products#new
#                        edit_operational_portal_product GET    /operational_portal/products/:id/edit(.:format)                                                   operational_portal/products#edit
#                             operational_portal_product GET    /operational_portal/products/:id(.:format)                                                        operational_portal/products#show
#                                                        PATCH  /operational_portal/products/:id(.:format)                                                        operational_portal/products#update
#                                                        PUT    /operational_portal/products/:id(.:format)                                                        operational_portal/products#update
#                                                        DELETE /operational_portal/products/:id(.:format)                                                        operational_portal/products#destroy
#                    delete_file_operational_portal_part DELETE /operational_portal/parts/:id/delete_file(.:format)                                               operational_portal/parts#delete_file
#                    upload_file_operational_portal_part POST   /operational_portal/parts/:id/upload_file(.:format)                                               operational_portal/parts#upload_file
#                               operational_portal_parts GET    /operational_portal/parts(.:format)                                                               operational_portal/parts#index
#                                                        POST   /operational_portal/parts(.:format)                                                               operational_portal/parts#create
#                            new_operational_portal_part GET    /operational_portal/parts/new(.:format)                                                           operational_portal/parts#new
#                           edit_operational_portal_part GET    /operational_portal/parts/:id/edit(.:format)                                                      operational_portal/parts#edit
#                                operational_portal_part GET    /operational_portal/parts/:id(.:format)                                                           operational_portal/parts#show
#                                                        PATCH  /operational_portal/parts/:id(.:format)                                                           operational_portal/parts#update
#                                                        PUT    /operational_portal/parts/:id(.:format)                                                           operational_portal/parts#update
#                                                        DELETE /operational_portal/parts/:id(.:format)                                                           operational_portal/parts#destroy
#                    sync_price_operational_portal_order POST   /operational_portal/orders/:id/sync_price(.:format)                                               operational_portal/orders#sync_price
#               update_shipping_operational_portal_order PUT    /operational_portal/orders/:id/update_shipping(.:format)                                          operational_portal/orders#update_shipping
#               search_results_operational_portal_orders GET    /operational_portal/orders/search_results(.:format)                                               operational_portal/orders#search_results
#                              operational_portal_orders GET    /operational_portal/orders(.:format)                                                              operational_portal/orders#index
#                                                        POST   /operational_portal/orders(.:format)                                                              operational_portal/orders#create
#                           new_operational_portal_order GET    /operational_portal/orders/new(.:format)                                                          operational_portal/orders#new
#                          edit_operational_portal_order GET    /operational_portal/orders/:id/edit(.:format)                                                     operational_portal/orders#edit
#                               operational_portal_order GET    /operational_portal/orders/:id(.:format)                                                          operational_portal/orders#show
#                                                        PATCH  /operational_portal/orders/:id(.:format)                                                          operational_portal/orders#update
#                                                        PUT    /operational_portal/orders/:id(.:format)                                                          operational_portal/orders#update
#                                                        DELETE /operational_portal/orders/:id(.:format)                                                          operational_portal/orders#destroy
#          add_message_operational_portal_support_ticket POST   /operational_portal/support_tickets/:id/add_message(.:format)                                     operational_portal/support_tickets#add_message
# preview_message_file_operational_portal_support_ticket GET    /operational_portal/support_tickets/:id/preview_message_file/:message_id(.:format)                operational_portal/support_tickets#preview_message_file
#      customer_users_operational_portal_support_tickets GET    /operational_portal/support_tickets/customer_users(.:format)                                      operational_portal/support_tickets#customer_users
# form_user_selection_operational_portal_support_tickets GET    /operational_portal/support_tickets/form_user_selection(.:format)                                 operational_portal/support_tickets#form_user_selection
#                     operational_portal_support_tickets GET    /operational_portal/support_tickets(.:format)                                                     operational_portal/support_tickets#index
#                                                        POST   /operational_portal/support_tickets(.:format)                                                     operational_portal/support_tickets#create
#                  new_operational_portal_support_ticket GET    /operational_portal/support_tickets/new(.:format)                                                 operational_portal/support_tickets#new
#                 edit_operational_portal_support_ticket GET    /operational_portal/support_tickets/:id/edit(.:format)                                            operational_portal/support_tickets#edit
#                      operational_portal_support_ticket GET    /operational_portal/support_tickets/:id(.:format)                                                 operational_portal/support_tickets#show
#                                                        PATCH  /operational_portal/support_tickets/:id(.:format)                                                 operational_portal/support_tickets#update
#                                                        PUT    /operational_portal/support_tickets/:id(.:format)                                                 operational_portal/support_tickets#update
#                                                        DELETE /operational_portal/support_tickets/:id(.:format)                                                 operational_portal/support_tickets#destroy
#                            operational_portal_settings GET    /operational_portal/settings(.:format)                                                            operational_portal/settings#index
#                        edit_operational_portal_setting GET    /operational_portal/settings/:id/edit(.:format)                                                   operational_portal/settings#edit
#                             operational_portal_setting PATCH  /operational_portal/settings/:id(.:format)                                                        operational_portal/settings#update
#                                                        PUT    /operational_portal/settings/:id(.:format)                                                        operational_portal/settings#update
#              operational_portal_order_price_schedulers GET    /operational_portal/order_price_schedulers(.:format)                                              operational_portal/order_price_schedulers#index
#                               operational_portal_users GET    /operational_portal/users(.:format)                                                               operational_portal/users#index
#                                                        POST   /operational_portal/users(.:format)                                                               operational_portal/users#create
#                            new_operational_portal_user GET    /operational_portal/users/new(.:format)                                                           operational_portal/users#new
#                           edit_operational_portal_user GET    /operational_portal/users/:id/edit(.:format)                                                      operational_portal/users#edit
#                                operational_portal_user GET    /operational_portal/users/:id(.:format)                                                           operational_portal/users#show
#                                                        PATCH  /operational_portal/users/:id(.:format)                                                           operational_portal/users#update
#                                                        PUT    /operational_portal/users/:id(.:format)                                                           operational_portal/users#update
#                                                        DELETE /operational_portal/users/:id(.:format)                                                           operational_portal/users#destroy
#                      users_operational_portal_customer GET    /operational_portal/customers/:id/users(.:format)                                                 operational_portal/customers#users
#                           operational_portal_customers GET    /operational_portal/customers(.:format)                                                           operational_portal/customers#index
#                                                        POST   /operational_portal/customers(.:format)                                                           operational_portal/customers#create
#                        new_operational_portal_customer GET    /operational_portal/customers/new(.:format)                                                       operational_portal/customers#new
#                       edit_operational_portal_customer GET    /operational_portal/customers/:id/edit(.:format)                                                  operational_portal/customers#edit
#                            operational_portal_customer GET    /operational_portal/customers/:id(.:format)                                                       operational_portal/customers#show
#                                                        PATCH  /operational_portal/customers/:id(.:format)                                                       operational_portal/customers#update
#                                                        PUT    /operational_portal/customers/:id(.:format)                                                       operational_portal/customers#update
#                                                        DELETE /operational_portal/customers/:id(.:format)                                                       operational_portal/customers#destroy
#                         operational_portal_invitations POST   /operational_portal/invitations(.:format)                                                         operational_portal/invitations#create
#                      new_operational_portal_invitation GET    /operational_portal/invitations/new(.:format)                                                     operational_portal/invitations#new
#                        edit_operational_portal_profile GET    /operational_portal/profile/edit(.:format)                                                        operational_portal/profiles#edit
#                             operational_portal_profile GET    /operational_portal/profile(.:format)                                                             operational_portal/profiles#show
#                                                        PATCH  /operational_portal/profile(.:format)                                                             operational_portal/profiles#update
#                                                        PUT    /operational_portal/profile(.:format)                                                             operational_portal/profiles#update
#                       add_item_operational_portal_cart POST   /operational_portal/cart/add_item(.:format)                                                       operational_portal/carts#add_item
#                                operational_portal_cart GET    /operational_portal/cart(.:format)                                                                operational_portal/carts#show
#                                   customer_portal_root GET    /customer_portal(.:format)                                                                        customer_portal/customer_portal/dashboard#index
#                                 customer_portal_orders GET    /customer_portal/orders(.:format)                                                                 customer_portal/orders#index
#                                                        POST   /customer_portal/orders(.:format)                                                                 customer_portal/orders#create
#                              new_customer_portal_order GET    /customer_portal/orders/new(.:format)                                                             customer_portal/orders#new
#                             edit_customer_portal_order GET    /customer_portal/orders/:id/edit(.:format)                                                        customer_portal/orders#edit
#                                  customer_portal_order GET    /customer_portal/orders/:id(.:format)                                                             customer_portal/orders#show
#                                                        PATCH  /customer_portal/orders/:id(.:format)                                                             customer_portal/orders#update
#                                                        PUT    /customer_portal/orders/:id(.:format)                                                             customer_portal/orders#update
#                                                        DELETE /customer_portal/orders/:id(.:format)                                                             customer_portal/orders#destroy
#             add_message_customer_portal_support_ticket POST   /customer_portal/support_tickets/:id/add_message(.:format)                                        customer_portal/support_tickets#add_message
#                        customer_portal_support_tickets GET    /customer_portal/support_tickets(.:format)                                                        customer_portal/support_tickets#index
#                                                        POST   /customer_portal/support_tickets(.:format)                                                        customer_portal/support_tickets#create
#                     new_customer_portal_support_ticket GET    /customer_portal/support_tickets/new(.:format)                                                    customer_portal/support_tickets#new
#                    edit_customer_portal_support_ticket GET    /customer_portal/support_tickets/:id/edit(.:format)                                               customer_portal/support_tickets#edit
#                         customer_portal_support_ticket GET    /customer_portal/support_tickets/:id(.:format)                                                    customer_portal/support_tickets#show
#                                                        PATCH  /customer_portal/support_tickets/:id(.:format)                                                    customer_portal/support_tickets#update
#                                                        PUT    /customer_portal/support_tickets/:id(.:format)                                                    customer_portal/support_tickets#update
#                                                        DELETE /customer_portal/support_tickets/:id(.:format)                                                    customer_portal/support_tickets#destroy
#                           edit_customer_portal_profile GET    /customer_portal/profile/edit(.:format)                                                           customer_portal/profiles#edit
#                                customer_portal_profile GET    /customer_portal/profile(.:format)                                                                customer_portal/profiles#show
#                                                        PATCH  /customer_portal/profile(.:format)                                                                customer_portal/profiles#update
#                                                        PUT    /customer_portal/profile(.:format)                                                                customer_portal/profiles#update
#                          add_item_customer_portal_cart POST   /customer_portal/cart/add_item(.:format)                                                          customer_portal/carts#add_item
#                                   customer_portal_cart GET    /customer_portal/cart(.:format)                                                                   customer_portal/carts#show
#                                               products GET    /products(.:format)                                                                               products#index
#                                                product GET    /products/:id(.:format)                                                                           products#show
#                                                  parts GET    /parts(.:format)                                                                                  parts#index
#                                                   part GET    /parts/:id(.:format)                                                                              parts#show
#                                     rails_health_check GET    /up(.:format)                                                                                     rails/health#show
#                       turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#                       turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#                      turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#                          rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#                             rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#                          rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#                    rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#                          rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#                           rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#                         rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                                        POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#                      new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#                          rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#               new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#                  rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#                  rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
#               rails_conductor_inbound_email_incinerate POST   /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                                     rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                               rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                                        GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                              rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#                        rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                                        GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                                     rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                              update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                                   rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
