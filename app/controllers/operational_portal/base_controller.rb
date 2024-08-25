# frozen_string_literal: true

class OperationalPortal::BaseController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      if current_user.present?
        format.html { redirect_to operational_root_path, alert: exception.message }
        format.turbo_stream { render 'errors/unauthorized', status: :unauthorized }
      else
        format.html { redirect_to new_user_session_path, alert: 'You need to sign in or sign up before continuing.' }
      end
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, 'operational_portal')
  end
end
