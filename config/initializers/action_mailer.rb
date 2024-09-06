if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    user_name: ENV.fetch('MAILER_USERNAME', nil),
    password: ENV.fetch('MAILER_PASSWORD', nil),
    address: ENV.fetch('MAILER_ADDRESS', nil),
    port: ENV.fetch('MAILER_PORT', 587),
    domain: ENV.fetch('APP_DOMAIN', nil),
    authentication: :plain,
    enable_starttls_auto: true
  }
end
