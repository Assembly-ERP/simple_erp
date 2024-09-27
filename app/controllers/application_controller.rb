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

  def or_q(query)
    query.present? ? ' OR' : ''
  end
end
