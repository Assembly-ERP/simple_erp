# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def theme
    '--primary: #214290; --primary-text: #fff; --secondary: #589245; --secondary-text: #fff;'
  end

  def orders_path_for(user)
    if user.operational_user?
      operational_portal_orders_path
    else
      customer_portal_orders_path
    end
  end

  def support_tickets_path_for(user)
    if user.operational_user?
      operational_portal_support_tickets_path
    else
      customer_portal_support_tickets_path
    end
  end
end
