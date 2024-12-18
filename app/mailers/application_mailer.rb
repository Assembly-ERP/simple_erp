# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILER_SENDER', 'from@example.com')
  layout 'mailer'
end
