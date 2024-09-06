if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    user_name: ENV.fetch('SENDGRID_USERNAME', nil),
    password: ENV.fetch('SENDGRID_PASSWORD', nil),
    domain: ENV.fetch('APP_DOMAIN', nil),
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }
end
