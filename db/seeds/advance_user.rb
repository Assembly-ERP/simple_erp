# frozen_string_literal: true

if ENV.fetch('SUPER_USER_EMAIL', '').present? && ENV.fetch('SUPER_USER_PASSWORD', '').present?
  User.create(
    email: ENV.fetch('SUPER_USER_EMAIL', ''),
    password: ENV.fetch('SUPER_USER_PASSWORD', ''),
    password_confirmation: ENV.fetch('SUPER_USER_PASSWORD', ''),
    role: 'admin',
    advance: true,
    first_name: 'Support',
    last_name: 'Admin',
    confirmed_at: Time.now.utc
  )
end
