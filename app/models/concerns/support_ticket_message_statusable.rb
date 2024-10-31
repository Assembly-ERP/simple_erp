# frozen_string_literal: true

module SupportTicketMessageStatusable
  extend ActiveSupport::Concern

  included do
    after_save :auto_update_status_by_iteraction

    private

    def auto_update_status_by_iteraction
      if user.customer_id.present?
        support_ticket.update_column(:status, 'waiting_for_support')
      else
        support_ticket.update_column(:status, 'waiting_for_customer')
      end
    end
  end
end
