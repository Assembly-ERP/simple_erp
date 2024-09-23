# frozen_string_literal: true

User.create(
  email: ENV.fetch('INIT_ADMIN_EMAIL', 'admin@example.com'),
  password: ENV.fetch('INIT_ADMIN_PASSWORD', 'password'),
  password_confirmation: ENV.fetch('INIT_ADMIN_PASSWORD', 'password'),
  role: 'admin',
  first_name: ENV.fetch('INIT_ADMIN_FIRST_NAME', 'Admin'),
  last_name: ENV.fetch('INIT_ADMIN_LAST_NAME', 'User'),
  confirmed_at: Time.now.utc
)

User.create(
  email: ENV.fetch('INIT_MANAGER_EMAIL', 'admin@example.com'),
  password: ENV.fetch('INIT_MANAGER_PASSWORD', 'password'),
  password_confirmation: ENV.fetch('INIT_MANAGER_PASSWORD', 'password'),
  role: 'manager',
  first_name: ENV.fetch('INIT_MANAGER_FIRST_NAME', 'Manager'),
  last_name: ENV.fetch('INIT_MANAGER_LAST_NAME', 'User'),
  confirmed_at: Time.now.utc
)
