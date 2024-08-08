# frozen_string_literal: true

class OperationalPortal::BaseController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      if current_user.present?
        format.html { redirect_to operational_portal_dashboard_index_path, alert: exception.message }
      else
        format.html { redirect_to new_user_session_path, alert: 'You need to sign in or sign up before continuing.' }
      end
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, 'operational_portal')
  end
end
