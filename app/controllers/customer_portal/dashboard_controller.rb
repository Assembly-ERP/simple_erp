# frozen_string_literal: true

module CustomerPortal
  class DashboardController < CustomerPortal::BaseController
    authorize_resource class: false

    def index
      @orders = current_user.customer.orders
      @support_tickets = current_user.customer.support_tickets
    end
  end
end
