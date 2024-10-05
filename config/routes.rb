# typed: ignore

require 'sidekiq/web'

Rails.application.routes.draw do
  unauthenticated :user do
    root 'home#index'
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }

  authenticate :user, -> { _1.advance_admin_user? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticated :user, -> { _1.operational_user? } do
    get '/', to: redirect('/operational_portal')
  end

  authenticated :user, -> { _1.customer_user? } do
    get '/', to: redirect('/customer_portal/catalog')
  end

  # Dashboards
  get '/operational_portal', to: 'operational_portal/dashboard#index', as: :operational_root
  # get '/customer_portal', to: 'customer_portal/dashboard#index', as: :customer_root

  # Operational portal
  get '/operational_portal/manage', to: redirect('/operational_portal/users')

  namespace :operational_portal do
    resources :catalog, only: [:index] do
      collection do
        get :search
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
        get :qoute_or_invoice
        put :update_summary
        delete :cancel
      end
      collection do
        get :search
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
    resources :customer_imports, only: %i[index create]
    resources :settings, only: %i[index edit update]
    resources :order_price_schedulers, only: %i[index]
    resources :users
    resources :brandings, path: 'branding', only: %i[edit update]
    resources :customers do
      collection do
        get :search
      end
      member do
        get :users
      end
    end
    resources :invitations, only: %i[new create]
    resource :profile, only: %i[show edit update]
  end

  # Customer portal
  namespace :customer_portal do
    resources :catalog, only: [:index]
    resources :orders
    resources :support_tickets do
      member do
        post 'add_message', to: 'support_tickets#add_message'
      end
    end
    resource :profile, only: %i[show edit update]
    resources :cart, only: %i[index create delete]
  end

  # API
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

  # Health check route for application monitoring
  get 'up' => 'rails/health#show', as: :rails_health_check
end

# == Route Map
#
#                                                 Prefix Verb   URI Pattern                                                                                       Controller#Action
#                                                   root GET    /                                                                                                 home#index
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
#                                 accept_user_invitation GET    /users/invitation/accept(.:format)                                                                users/invitations#edit
#                                 remove_user_invitation GET    /users/invitation/remove(.:format)                                                                users/invitations#destroy
#                                    new_user_invitation GET    /users/invitation/new(.:format)                                                                   users/invitations#new
#                                        user_invitation PATCH  /users/invitation(.:format)                                                                       users/invitations#update
#                                                        PUT    /users/invitation(.:format)                                                                       users/invitations#update
#                                                        POST   /users/invitation(.:format)                                                                       users/invitations#create
#                                            sidekiq_web        /sidekiq                                                                                          Sidekiq::Web
#                                                        GET    /                                                                                                 redirect(301, /operational_portal)
#                                                        GET    /                                                                                                 redirect(301, /customer_portal/catalog)
#                                       operational_root GET    /operational_portal(.:format)                                                                     operational_portal/dashboard#index
#                              operational_portal_manage GET    /operational_portal/manage(.:format)                                                              redirect(301, /operational_portal/users)
#                search_operational_portal_catalog_index GET    /operational_portal/catalog/search(.:format)                                                      operational_portal/catalog#search
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
#                               operational_portal_parts GET    /operational_portal/parts(.:format)                                                               operational_portal/parts#index
#                                                        POST   /operational_portal/parts(.:format)                                                               operational_portal/parts#create
#                            new_operational_portal_part GET    /operational_portal/parts/new(.:format)                                                           operational_portal/parts#new
#                           edit_operational_portal_part GET    /operational_portal/parts/:id/edit(.:format)                                                      operational_portal/parts#edit
#                                operational_portal_part GET    /operational_portal/parts/:id(.:format)                                                           operational_portal/parts#show
#                                                        PATCH  /operational_portal/parts/:id(.:format)                                                           operational_portal/parts#update
#                                                        PUT    /operational_portal/parts/:id(.:format)                                                           operational_portal/parts#update
#                                                        DELETE /operational_portal/parts/:id(.:format)                                                           operational_portal/parts#destroy
#                   make_ticket_operational_portal_order GET    /operational_portal/orders/:id/make_ticket(.:format)                                              operational_portal/orders#make_ticket
#              qoute_or_invoice_operational_portal_order GET    /operational_portal/orders/:id/qoute_or_invoice(.:format)                                         operational_portal/orders#qoute_or_invoice
#                update_summary_operational_portal_order PUT    /operational_portal/orders/:id/update_summary(.:format)                                           operational_portal/orders#update_summary
#                        cancel_operational_portal_order DELETE /operational_portal/orders/:id/cancel(.:format)                                                   operational_portal/orders#cancel
#                       search_operational_portal_orders GET    /operational_portal/orders/search(.:format)                                                       operational_portal/orders#search
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
#                    operational_portal_customer_imports GET    /operational_portal/customer_imports(.:format)                                                    operational_portal/customer_imports#index
#                                                        POST   /operational_portal/customer_imports(.:format)                                                    operational_portal/customer_imports#create
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
#                       edit_operational_portal_branding GET    /operational_portal/branding/:id/edit(.:format)                                                   operational_portal/brandings#edit
#                            operational_portal_branding PATCH  /operational_portal/branding/:id(.:format)                                                        operational_portal/brandings#update
#                                                        PUT    /operational_portal/branding/:id(.:format)                                                        operational_portal/brandings#update
#                    search_operational_portal_customers GET    /operational_portal/customers/search(.:format)                                                    operational_portal/customers#search
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
#                          customer_portal_catalog_index GET    /customer_portal/catalog(.:format)                                                                customer_portal/catalog#index
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
#                             customer_portal_cart_index GET    /customer_portal/cart(.:format)                                                                   customer_portal/cart#index
#                                                        POST   /customer_portal/cart(.:format)                                                                   customer_portal/cart#create
#                                   me_api_v1_auth_index GET    /api/v1/auth/me(.:format)                                                                         api/v1/auth#me
#                        refresh_token_api_v1_auth_index PUT    /api/v1/auth/refresh_token(.:format)                                                              api/v1/auth#refresh_token
#                              sign_in_api_v1_auth_index POST   /api/v1/auth/sign_in(.:format)                                                                    api/v1/auth#sign_in
#                                           api_v1_parts GET    /api/v1/parts(.:format)                                                                           api/v1/parts#index
#                                                        POST   /api/v1/parts(.:format)                                                                           api/v1/parts#create
#                                        new_api_v1_part GET    /api/v1/parts/new(.:format)                                                                       api/v1/parts#new
#                                       edit_api_v1_part GET    /api/v1/parts/:id/edit(.:format)                                                                  api/v1/parts#edit
#                                            api_v1_part GET    /api/v1/parts/:id(.:format)                                                                       api/v1/parts#show
#                                                        PATCH  /api/v1/parts/:id(.:format)                                                                       api/v1/parts#update
#                                                        PUT    /api/v1/parts/:id(.:format)                                                                       api/v1/parts#update
#                                                        DELETE /api/v1/parts/:id(.:format)                                                                       api/v1/parts#destroy
#                                        api_v1_products GET    /api/v1/products(.:format)                                                                        api/v1/products#index
#                                                        POST   /api/v1/products(.:format)                                                                        api/v1/products#create
#                                     new_api_v1_product GET    /api/v1/products/new(.:format)                                                                    api/v1/products#new
#                                    edit_api_v1_product GET    /api/v1/products/:id/edit(.:format)                                                               api/v1/products#edit
#                                         api_v1_product GET    /api/v1/products/:id(.:format)                                                                    api/v1/products#show
#                                                        PATCH  /api/v1/products/:id(.:format)                                                                    api/v1/products#update
#                                                        PUT    /api/v1/products/:id(.:format)                                                                    api/v1/products#update
#                                                        DELETE /api/v1/products/:id(.:format)                                                                    api/v1/products#destroy
#                                          api_v1_orders GET    /api/v1/orders(.:format)                                                                          api/v1/orders#index
#                                                        POST   /api/v1/orders(.:format)                                                                          api/v1/orders#create
#                                       new_api_v1_order GET    /api/v1/orders/new(.:format)                                                                      api/v1/orders#new
#                                      edit_api_v1_order GET    /api/v1/orders/:id/edit(.:format)                                                                 api/v1/orders#edit
#                                           api_v1_order GET    /api/v1/orders/:id(.:format)                                                                      api/v1/orders#show
#                                                        PATCH  /api/v1/orders/:id(.:format)                                                                      api/v1/orders#update
#                                                        PUT    /api/v1/orders/:id(.:format)                                                                      api/v1/orders#update
#                                                        DELETE /api/v1/orders/:id(.:format)                                                                      api/v1/orders#destroy
#                                 api_v1_support_tickets GET    /api/v1/support_tickets(.:format)                                                                 api/v1/support_tickets#index
#                                                        POST   /api/v1/support_tickets(.:format)                                                                 api/v1/support_tickets#create
#                              new_api_v1_support_ticket GET    /api/v1/support_tickets/new(.:format)                                                             api/v1/support_tickets#new
#                             edit_api_v1_support_ticket GET    /api/v1/support_tickets/:id/edit(.:format)                                                        api/v1/support_tickets#edit
#                                  api_v1_support_ticket GET    /api/v1/support_tickets/:id(.:format)                                                             api/v1/support_tickets#show
#                                                        PATCH  /api/v1/support_tickets/:id(.:format)                                                             api/v1/support_tickets#update
#                                                        PUT    /api/v1/support_tickets/:id(.:format)                                                             api/v1/support_tickets#update
#                                                        DELETE /api/v1/support_tickets/:id(.:format)                                                             api/v1/support_tickets#destroy
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
