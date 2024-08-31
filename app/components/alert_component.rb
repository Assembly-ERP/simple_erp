# frozen_string_literal: true
# typed: true

class AlertComponent < ViewComponent::Base
  extend T::Sig

  NOTIFY_TYPES = {
    success: 'text-green-600 rounded-lg bg-green-50 border border-green-500',
    error: 'text-red-600 rounded-lg bg-red-50 border border-red-600'
  }.freeze

  sig { params(message: String, notif_type: Symbol).void }
  def initialize(message:, notif_type: :success)
    @message = message
    @notif_type = notif_type
    super
  end

  def alert_classes
    NOTIFY_TYPES[@notif_type] || NOTIFY_TYPES[:success]
  end
end
