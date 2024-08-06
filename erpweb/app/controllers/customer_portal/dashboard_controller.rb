# frozen_string_literal: true

# app/controllers/customer_portal/dashboard_controller.rb
module CustomerPortal
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_customer_user

    def index
      @orders = current_user.customer.orders if current_user.customer
      @support_tickets = current_user.customer.support_tickets if current_user.customer
      # else
      # Rails.logger.debug "Current user does not have an associated customer"
      # @orders = []
      # @support_tickets = []
    end

    private

    def ensure_customer_user
      return if current_user.customer_user?

      redirect_to root_path, alert: 'You do not have access to the customer portal.'
    end

    def generate_jws_token(user)
      payload = { user_id: user.id }
      secret = Rails.application.secrets.secret_key_base
      JWT.encode(payload, secret, 'HS256')
    end
  end
end
