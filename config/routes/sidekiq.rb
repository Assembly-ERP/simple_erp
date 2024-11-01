# frozen_string_literal: true

authenticate :user, -> { _1.advance_admin_user? } do
  mount Sidekiq::Web => '/sidekiq'
end
