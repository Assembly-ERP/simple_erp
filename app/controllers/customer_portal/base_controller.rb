# frozen_string_literal: true

class CustomerPortal::BaseController < ApplicationController
  layout 'customer'

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      if current_user.present?
        format.html { redirect_to root_path, alert: exception.message }
        format.turbo_stream { render 'errors/unauthorized', status: :unauthorized }
      else
        format.html { redirect_to new_user_session_path, alert: I18n.t('devise.failure.unauthenticated') }
        format.turbo_stream do
          redirect_to new_user_session_path, alert: I18n.t('devise.failure.unauthenticated')
        end
      end
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, 'customer_portal')
  end
end
