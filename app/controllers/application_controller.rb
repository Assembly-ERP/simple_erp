# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  def after_sign_in_path_for(resource)
    if resource.operational_user?
      operational_root_path
    elsif resource.customer_user?
      customer_root_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  private

  def more_q(query)
    query.present? ? ' OR ' : ' '
  end

  def customer_document(customer)
    {
      id: customer.id.to_s,
      name: customer.name,
      phone: customer.phone,
      street: customer.street,
      city: customer.city,
      state: customer.state,
      postal_code: customer.postal_code,
      discount: customer.discount.to_f
    }
  end
end
