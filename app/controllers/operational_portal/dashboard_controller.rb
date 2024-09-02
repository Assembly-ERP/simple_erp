# frozen_string_literal: true

module OperationalPortal
  class DashboardController < OperationalPortal::NormalOperationController
    authorize_resource class: false

    def index
      @orders = Order.order(created_at: :desc).limit(10).with_customer.with_order_status.not_voided
      @support_tickets = SupportTicket.order(created_at: :desc).limit(10).with_customer
    end
  end
end
