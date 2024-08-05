# app/controllers/operational_portal/dashboard_controller.rb
module OperationalPortal
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_operational_user

    def index
      @orders = Order.order(created_at: :desc).limit(10)
      @support_tickets = SupportTicket.order(created_at: :desc).limit(10)
    end

  private

  def ensure_operational_user
    redirect_to customer_root_path unless current_user.operational_user?
  end
end
end