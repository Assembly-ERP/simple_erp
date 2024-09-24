# frozen_string_literal: true

if ENV.fetch('SUPER_USER_EMAIL', '').present? && ENV.fetch('SUPER_USER_PASSWORD', '').present?
  User.create(
    email: ENV.fetch('SUPER_USER_EMAIL', ''),
    password: ENV.fetch('SUPER_USER_PASSWORD', ''),
    password_confirmation: ENV.fetch('SUPER_USER_PASSWORD', ''),
    role: 'super_user',
    first_name: 'Super',
    last_name: 'User',
    confirmed_at: Time.now.utc
  )
end

if ENV.fetch('INIT_ADMIN_EMAIL', '').present? && ENV.fetch('INIT_ADMIN_PASSWORD', '').present?
  User.create(
    email: ENV.fetch('INIT_ADMIN_EMAIL', ''),
    password: ENV.fetch('INIT_ADMIN_PASSWORD', ''),
    password_confirmation: ENV.fetch('INIT_ADMIN_PASSWORD', ''),
    role: 'super_user',
    first_name: ENV.fetch('INIT_ADMIN_FIRST_NAME', 'Admin'),
    last_name: ENV.fetch('INIT_ADMIN_LAST_NAME', 'User'),
    confirmed_at: Time.now.utc
  )
end

if ENV.fetch('INIT_MANAGER_EMAIL', '').present? && ENV.fetch('INIT_MANAGER_PASSWORD', '').present?
  User.create(
    email: ENV.fetch('INIT_MANAGER_EMAIL', ''),
    password: ENV.fetch('INIT_MANAGER_PASSWORD', ''),
    password_confirmation: ENV.fetch('INIT_MANAGER_PASSWORD', ''),
    role: 'super_user',
    first_name: ENV.fetch('INIT_MANAGER_FIRST_NAME', 'Manager'),
    last_name: ENV.fetch('INIT_MANAGER_LAST_NAME', 'User'),
    confirmed_at: Time.now.utc
  )
end
