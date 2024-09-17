# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def theme
    branding = Branding.client

    "--primary: #{branding.primary_color}; --primary-text: #{branding.primary_text_color}; " \
      "--secondary: #{branding.secondary_color}; --secondary-text: #{branding.secondary_text_color};"
  end

  def value_from_percentage(value, percentage)
    value.to_f * (percentage.to_f / 100).to_f
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
