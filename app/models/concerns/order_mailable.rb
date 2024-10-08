# frozen_string_literal: true

module OrderMailable
  extend ActiveSupport::Concern

  included do
    after_commit :send_quote_or_invoice, if: :send_quote_or_invoice_condition?

    private

    def send_quote_or_invoice_condition?
      send_quote_assignees && (total_amount_previously_changed? || order_status_previously_changed?)
    end

    def send_quote_or_invoice
      return if users.count.zero?
      return unless order_status.allow_change

      OrderMailer.send_quote_or_invoice(self).deliver_later
    end
  end
end
