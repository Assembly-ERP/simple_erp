# frozen_string_literal: true
# typed: true

class NotificationComponent < ViewComponent::Base
  extend T::Sig

  attr_reader :notif_type, :message, :duration

  sig { params(message: String, notif_type: String, duration: String).void }
  def initialize(message:, notif_type: 'success', duration: '3000')
    @notif_type = notif_type
    @message = message
    @duration = duration
    super
  end
end
