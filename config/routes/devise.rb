# frozen_string_literal: true

devise_for :users, skip: [:registrations], controllers: {
  # registrations: 'users/registrations',
  invitations: 'users/invitations'
}
