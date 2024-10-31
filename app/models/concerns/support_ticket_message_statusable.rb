# frozen_string_literal: true

module SupportTicketMessageStatusable
  extend ActiveSupport::Concern

  included do
    after_save :auto_update_status_to_open

    private

    def auto_update_status_to_open
      support_ticket.update_column(:status, 'open') if support_ticket.status == 'pending'
    end
  end
end
