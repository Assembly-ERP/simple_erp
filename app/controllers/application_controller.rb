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

  private

  def or_q(query)
    query.present? ? ' OR' : ''
  end
end
