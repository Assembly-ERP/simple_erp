# frozen_string_literal: true

# app/controllers/operational_portal/dashboard_controller.rb
module OperationalPortal
  class DashboardController < OperationalPortal::BaseController
    authorize_resource class: false

    def index
      @orders = Order.order(created_at: :desc).limit(10)
      @support_tickets = SupportTicket.order(created_at: :desc).limit(10)
    end
  end
end
