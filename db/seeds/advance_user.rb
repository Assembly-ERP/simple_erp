# frozen_string_literal: true

if ENV.fetch('SUPER_USER_EMAIL', 'admin@example.com').present? &&
   ENV.fetch('SUPER_USER_PASSWORD', '').present?

  User.create(
    email: ENV.fetch('SUPER_USER_EMAIL', 'admin@example.com'),
    password: ENV.fetch('SUPER_USER_PASSWORD', 'password'),
    password_confirmation: ENV.fetch('SUPER_USER_PASSWORD', 'password'),
    role: 'super_user',
    first_name: 'Super',
    last_name: 'User',
    confirmed_at: Time.now.utc
  )
end
