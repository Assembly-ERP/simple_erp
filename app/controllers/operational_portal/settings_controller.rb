# frozen_string_literal: true

module OperationalPortal
  class SettingsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin_user

    def index
      @settings = Setting.all
    end

    def edit
      @setting = Setting.find(params[:id])
    end

    def update
      @setting = Setting.find(params[:id])
      if @setting.update(setting_params)
        redirect_to operational_portal_settings_path, notice: "#{@setting.key} updated successfully."
      else
        render :edit
      end
    end

    private

    def setting_params
      params.require(:setting).permit(:value)
    end

    def ensure_admin_user
      return if admin_user?

      redirect_to root_path, alert: 'You are not authorized to access this section.'
    end

    def admin_user?
      current_user.role == 'admin'
    end
  end
end
