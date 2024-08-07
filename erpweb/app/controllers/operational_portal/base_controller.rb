# frozen_string_literal: true

class OperationalPortal::BaseController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to operational_portal_dashboard_index_path, alert: exception.message }
      # format.turbo_stream { render 'errors/unauthorized', status: :unauthorized }
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, 'operational_portal')
  end
end
