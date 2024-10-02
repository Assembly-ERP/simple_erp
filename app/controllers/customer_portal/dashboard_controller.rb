# frozen_string_literal: true

module CustomerPortal
  class DashboardController < BaseController
    authorize_resource class: false

    def index
      @orders = current_user.customer.orders if current_user.customer
      @support_tickets = current_user.customer.support_tickets if current_user.customer
    end
  end
end
